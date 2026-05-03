import SwiftUI

enum GoalsServiceError: Error {
    case DateError
}

struct GoalsService {
    var goals: [Goal]

    func progressByGoal() throws -> [Goal.ID: Double] {
        var dictionary: [Goal.ID: Double] = [:]

        for goal in goals {
            let accumulated = try GoalService(goal: goal).accumulated()
            if goal.amount == 0 {
                dictionary[goal.id] = 0
            } else {
                let value = accumulated / goal.amount
                dictionary[goal.id] = NSDecimalNumber(decimal: value).doubleValue
            }
        }

        return dictionary
    }
}
