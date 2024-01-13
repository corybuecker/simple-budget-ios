import SwiftUI

struct GoalService {
  private let goal: Goal
  private let day: Double = 60 * 60 * 24.0

  init(goal: Goal) {
    self.goal = goal
  }

  func amortized() -> Decimal {
    if Date() >= self.goal.targetDate {
      return Decimal(self.goal.amount)
    }

    return dailyAmount() * Decimal(elapsedDays())
  }

  func dailyAmount() -> Decimal {
    if Date() >= self.goal.targetDate {
      return Decimal(0)
    }

    if Date() < startDate() {
      return Decimal(0)
    }

    return Decimal(self.goal.amount)
      / Decimal(DateInterval(start: startDate(), end: self.goal.targetDate).duration / day)
  }

  private func elapsedDays() -> Double {
    if Date() < startDate() {
      return 0
    }

    return DateInterval(start: startDate(), end: Date()).duration / day
  }

  private func startDate() -> Date {
    switch self.goal.recurrence {
    case GoalRecurrence.daily:
      return Calendar.current.date(byAdding: .day, value: -1, to: self.goal.targetDate)!
    case GoalRecurrence.weekly:
      return Calendar.current.date(byAdding: .weekOfYear, value: -1, to: self.goal.targetDate)!
    case GoalRecurrence.monthly:
      return Calendar.current.date(byAdding: .month, value: -1, to: self.goal.targetDate)!
    case GoalRecurrence.yearly:
      return Calendar.current.date(byAdding: .year, value: -1, to: self.goal.targetDate)!
    }
  }
}
