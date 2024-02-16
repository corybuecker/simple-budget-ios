import SwiftData

typealias Envelope = EnvelopeV102.Envelope

struct EnvelopeV102 {

  @Model
  class Envelope {
    var name: String = ""
    var amount: Double = 0.0

    init(name: String, amount: Double) {
      self.name = name
      self.amount = amount
    }
  }
}
