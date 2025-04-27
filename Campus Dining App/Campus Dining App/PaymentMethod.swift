import Foundation

/// Payment options
enum PaymentMethod: String, CaseIterable, Identifiable {
  case creditCard     = "Credit Card"
  case debitCard      = "Debit Card"
  case netBanking     = "Net Banking"
  case upi            = "Apple Pay"
  case cashOnDelivery = "Cash on Delivery"

  var id: String { rawValue }
}
