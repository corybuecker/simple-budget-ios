import SwiftUI

struct ReportService {
    private var accounts: [Account] = []
    private var envelopes: [Envelope] = []
    private var goals: [Goal] = []

    init(accounts: [Account], envelopes: [Envelope], goals: [Goal]) {
        self.accounts = accounts
        self.envelopes = envelopes
        self.goals = goals
    }

    func remaining() throws -> Decimal {
        let accountTotal: Decimal = try accounts.reduce(0) { result, account throws -> Decimal in
            let addition = account.isDebt ? -1 * account.balance : account.balance

            return result + addition
        }

        let envelopeTotal = try envelopes.reduce(0) { result, envelope throws -> Decimal in
            return result - envelope.amount
        }

        let goalsTotal = try goals.reduce(0) { result, goal throws -> Decimal in
            let goalService = GoalService(goal: goal)
            let accumulated = try goalService.accumulated()

            return result - accumulated
        }

        return accountTotal + envelopeTotal + goalsTotal
    }

    func remainingTime() throws -> Decimal {
        var now = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date.now)

        now.day = 1
        now.hour = 0
        now.minute = 0
        now.second = 0

        let startOfThisMonth = Calendar.current.date(from: now)!
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: startOfThisMonth)!
        let endOfThisMonth = Calendar.current.date(byAdding: .second, value: -1, to: nextMonth)!

        let secondsRemaining = Calendar.current.dateComponents([.second], from: Date.now, to: endOfThisMonth).second!

        return Decimal(secondsRemaining)
    }

    func remainingPerDay() throws -> Decimal {
        if try remainingTime() < 86400 {
            return try remaining()
        }

        return try remaining() / remainingTime() * 86400
    }
}
