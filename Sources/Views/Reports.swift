import SwiftData
import SwiftUI

struct Reports: View {
  @Environment(\.modelContext) var modelContext: ModelContext
  @Query var accounts: [Account]
  @Query var envelopes: [Envelope]
  @Query var goals: [Goal]

  var total: Decimal {
    let accountsTotal: Decimal = accounts.reduce(
      0,
      { accumulator, account in
        account.debt
          ? accumulator - Decimal(account.balance) : accumulator + Decimal(account.balance)
      })

    let envelopesTotal: Decimal = envelopes.reduce(
      0,
      { accumulator, envelope in
        accumulator - Decimal(envelope.amount)
      })

    let goalsTotal: Decimal = goals.reduce(
      0,
      { accumulator, goal in
        accumulator - GoalService(goal: goal).amortized()
      })

    return accountsTotal + envelopesTotal + goalsTotal
  }

  var daysRemaining: Int? = try? DateService().daysUntilEndOfMonth()

  func dailyEnvelope() -> Decimal {
    goals.reduce(
      0,
      { accumulator, goal in
        accumulator + GoalService(goal: goal).dailyAmount()
      })
  }

  func remainingAmount() -> Decimal {
    if let daysRemaining {
      total / Decimal(daysRemaining)
    } else {
      0
    }
  }

  @State private var lastRendered = Date()

  var body: some View {
    VStack {
      Breakdown(
        lastRendered: lastRendered, total: total, daysRemaining: daysRemaining,
        remainingAmount: remainingAmount(), dailyEnvelope: dailyEnvelope())
      Button("Refresh") {
        lastRendered = Date()
      }
    }
  }
}

struct Breakdown: View {
  let lastRendered: Date
  let total: Decimal
  let daysRemaining: Int?
  let remainingAmount: Decimal
  let dailyEnvelope: Decimal

  private var remainingAmountDbl: Double {
    NSDecimalNumber(decimal: remainingAmount).doubleValue
  }

  var body: some View {
    Gauge(value: remainingAmountDbl, in: 65...85) {
      Text(remainingAmount, format: .currency(code: "USD").precision(.fractionLength(0)))
    } currentValueLabel: {
      Text(remainingAmount, format: .currency(code: "USD").precision(.fractionLength(0)))
    } minimumValueLabel: {
      Text("65")
    } maximumValueLabel: {
      Text("85")
    }
    .gaugeStyle(.accessoryCircular)
    .scaleEffect(1.5)
    .padding()
    Text("Reports").foregroundColor(
      Color(
        red: Double.random(in: 0...1),
        green: Double.random(in: 0...1),
        blue: Double.random(in: 0...1)))
    Text(total, format: .currency(code: "USD"))
    if let daysRemaining {
      Text("Days remaining: \(daysRemaining)")
    }
    Section("Remaining") {
      Text(remainingAmount, format: .currency(code: "USD").precision(.fractionLength(4)))
    }

    Text(dailyEnvelope, format: .currency(code: "USD"))
  }
}
