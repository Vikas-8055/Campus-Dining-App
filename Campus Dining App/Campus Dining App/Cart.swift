import Foundation

class Cart: ObservableObject {
  @Published var items: [LocalMenuItem:Int] = [:]
  var totalItems: Int { items.values.reduce(0, +) }
  var totalPrice: Double {
    items.reduce(0) { acc, kv in
      acc + Double(kv.value) * kv.key.price
    }
  }
  func add(_ item: LocalMenuItem) {
    items[item, default: 0] += 1
  }
  func remove(_ item: LocalMenuItem) {
    if let c = items[item], c > 1 {
      items[item] = c - 1
    } else {
      items[item] = nil
    }
  }
  func clear() {
    items.removeAll()
  }
}
