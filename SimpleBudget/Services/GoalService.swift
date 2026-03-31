
import SwiftUI

enum GoalServiceError: Error {
    case DateError
}

struct GoalService {
    var goal: Goal

    func accumulated() throws -> Decimal {
        let startDate = try startDate()
        let endDate = goal.targetDate

        if Date() < startDate {
            return 0
        }

        if Date() > endDate {
            return goal.amount
        }

        let totalTimeInterval = endDate.timeIntervalSince(startDate)
        let amountPerIntervalTick = goal.amount / Decimal(totalTimeInterval)
        let timeInterval = Date().timeIntervalSince(startDate)

        return amountPerIntervalTick * Decimal(timeInterval)
    }

    private func duration() throws -> Int {
        0
    }

    private func startDate() throws -> Date {
        switch goal.recurrence {
        case .monthly:
            guard let startDate = Calendar.current.date(byAdding: .month, value: -1, to: goal.targetDate, wrappingComponents: false) else {
                throw GoalServiceError.DateError
            }
            return startDate
        case .yearly:
            guard let startDate = Calendar.current.date(byAdding: .year, value: -1, to: goal.targetDate, wrappingComponents: false) else {
                throw GoalServiceError.DateError
            }
            return startDate
        case .never:
            guard let startDate = goal.startDate else {
                throw GoalServiceError.DateError
            }
            return startDate
        }
    }
}
