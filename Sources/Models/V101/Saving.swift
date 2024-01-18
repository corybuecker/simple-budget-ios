import SwiftData

typealias Saving = SavingV101.Saving

struct SavingV101 {

  @Model
  class Saving {
    var name: String = ""
    var amount: Double = 0.0

    init(name: String, amount: Double) {
      self.name = name
      self.amount = amount
    }
  }
}
