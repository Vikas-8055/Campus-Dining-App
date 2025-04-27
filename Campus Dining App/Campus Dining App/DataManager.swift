import Foundation
import FirebaseAuth
import FirebaseFirestore

/// Central data manager: handles auth, Firestore, and order-state transitions.
class DataManager: ObservableObject {
    static let shared = DataManager()
    private init() { checkAuthStatus() }

    @Published var restaurants: [Restaurant] = []
    @Published var menuItems: [MenuItem] = []
    @Published var currentOrders: [Order] = []
    @Published var pastOrders: [Order] = []
    @Published var userProfile: UserProfile? = nil
    @Published var isAuthenticated = false
    @Published var hasOrderUpdates = false
    @Published var selectedTab: Int = 0

    let cartManager = CartManager()
    private let db = Firestore.firestore()
    private var orderListeners: [ListenerRegistration] = []

    func loadRestaurants() {
        db.collection("restaurants")
          .addSnapshotListener { snapshot, error in
              if let error = error {
                  print("❌ Restaurants listener:", error.localizedDescription)
                  return
              }
              self.restaurants = snapshot?.documents.compactMap {
                  Restaurant.fromFirestore(document: $0)
              } ?? []
          }
    }

    func fetchMenuItems(for restaurantId: String) {
        db.collection("restaurants")
          .document(restaurantId)
          .collection("menuItems")
          .getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error fetching menu items:", error.localizedDescription)
                return
            }
            self.menuItems = snapshot?.documents.compactMap {
                MenuItem.fromFirestore(document: $0)
            } ?? []
        }
    }

    func checkAuthStatus() {
        if let user = Auth.auth().currentUser {
            isAuthenticated = true
            loadUserProfile(userId: user.uid)
            fetchOrders()
            listenForOrderUpdates()
        } else {
            isAuthenticated = false
            userProfile = nil
            currentOrders = []
            pastOrders = []
            hasOrderUpdates = false
            removeOrderListeners()
        }
    }

    private func loadUserProfile(userId: String) {
        db.collection("users").document(userId).getDocument { snap, error in
            if let error = error {
                print("❌ Error fetching profile:", error.localizedDescription)
                return
            }
            guard let doc = snap, doc.exists,
                  let profile = UserProfile.fromFirestore(document: doc)
            else { return }
            self.userProfile = profile
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Bool)->Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                print("❌ Sign-in failed:", error.localizedDescription)
                completion(false)
            } else {
                self.checkAuthStatus()
                completion(true)
            }
        }
    }

    func signUp(email: String,
                password: String,
                name: String,
                completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { res, error in
            guard error == nil, let uid = res?.user.uid else {
                print("❌ Sign-up failed:", error?.localizedDescription ?? "unknown")
                completion(false); return
            }
            let profile = UserProfile(
                id: uid,
                name: name,
                email: email,
                dietaryPreferences: [],
                favoriteItems: []
            )
            self.db.collection("users").document(uid)
                .setData(profile.toFirestore()) { err in
                    guard err == nil else {
                        print("❌ Saving profile failed:", err!.localizedDescription)
                        completion(false); return
                    }
                    try? Auth.auth().signOut()
                    self.checkAuthStatus()
                    completion(true)
                }
        }
    }

    func signOut(completion: @escaping (Bool)->Void) {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            userProfile = nil
            currentOrders = []
            pastOrders = []
            menuItems = []
            hasOrderUpdates = false
            removeOrderListeners()
            completion(true)
        } catch {
            print("❌ Sign-out failed:", error.localizedDescription)
            completion(false)
        }
    }

    func updateUserProfile(profile: UserProfile, completion: @escaping (Bool)->Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(false); return
        }
        db.collection("users").document(uid)
            .setData(profile.toFirestore()) { error in
                if let error = error {
                    print("❌ Updating profile failed:", error.localizedDescription)
                    completion(false)
                } else {
                    self.userProfile = profile
                    completion(true)
                }
            }
    }

    func fetchOrders() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("orders")
          .whereField("userId", isEqualTo: uid)
          .getDocuments { snap, error in
            if let error = error {
                print("❌ Fetch orders failed:", error.localizedDescription)
                return
            }
            let all = snap?.documents.compactMap {
                Order.fromFirestore(document: $0)
            } ?? []

            self.currentOrders = all.filter {
                $0.status == .pending || $0.status == .preparing
            }
            self.pastOrders = all.filter {
                $0.status == .ready ||
                $0.status == .completed ||
                $0.status == .cancelled
            }
        }
    }

    func listenForOrderUpdates() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        removeOrderListeners()
        let listener = db.collection("orders")
            .whereField("userId", isEqualTo: uid)
            .whereField("status", in: ["pending", "preparing"])
            .addSnapshotListener { [weak self] _, _ in
                self?.hasOrderUpdates = true
            }
        orderListeners.append(listener)
    }

    private func removeOrderListeners() {
        orderListeners.forEach { $0.remove() }
        orderListeners.removeAll()
    }

    func viewedOrders() {
        hasOrderUpdates = false
    }

    func cancelOrder(orderId: String, completion: @escaping (Bool)->Void) {
        db.collection("orders").document(orderId)
            .updateData(["status": "cancelled"]) { error in
                if let error = error {
                    print("❌ Cancel order failed:", error.localizedDescription)
                    completion(false)
                } else {
                    self.viewedOrders()
                    completion(true)
                }
            }
    }

    func placeOrder(
        restaurantId: String,
        restaurantName: String,
        items: [OrderItem],
        totalAmount: Double,
        paymentMethod: String
    ) {
        let now = Date()
        var order = Order(
            id: UUID().uuidString,
            userId: Auth.auth().currentUser?.uid ?? "",
            restaurantId: restaurantId,
            restaurantName: restaurantName,
            items: items,
            totalAmount: totalAmount,
            status: .pending,
            placedTime: now,
            estimatedReadyTime: now.addingTimeInterval(10),
            paymentMethod: paymentMethod,
            paymentComplete: true
        )

        guard let docID = order.id else { return }
        db.collection("orders")
            .document(docID)
            .setData(order.toFirestore())

        currentOrders.append(order)

        NotificationService.shared.scheduleImmediateNotification(
            title: "Order Placed",
            body:  "Your order at \(restaurantName) has been placed."
        )

        NotificationService.shared.scheduleOrderReadyNotification(for: order)

        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            self?.markOrderReady(order)
        }
    }

    private func markOrderReady(_ order: Order) {
        guard let idx = currentOrders.firstIndex(where: { $0.id == order.id }) else { return }
        var updated = currentOrders.remove(at: idx)
        updated.status = .ready
        pastOrders.append(updated)

        NotificationManager.shared.addNotification(
            title:   "Order Ready",
            message: "Your order at \(updated.restaurantName) is now ready!",
            type:    .order
        )

        guard let docID = updated.id else { return }
        db.collection("orders")
            .document(docID)
            .updateData(["status": updated.status.rawValue]) { err in
                if let err = err {
                    print("❌ Failed to update status:", err.localizedDescription)
                }
            }
    }
}
