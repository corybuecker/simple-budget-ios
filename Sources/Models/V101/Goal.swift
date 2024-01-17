import SwiftData
import SwiftUI

enum GoalRecurrence: Codable {
  case daily
  case weekly
  case monthly
  case yearly
}

typealias Goal = GoalV101.Goal

struct GoalV101 {

  @Model
  class Goal {
    var name: String = ""
    var amount: Double = 0.0
    var recurrence: GoalRecurrence = GoalRecurrence.monthly
    var targetDate: Date = Date()

    init(name: String, amount: Double, recurrence: GoalRecurrence, targetDate: Date) {
      self.name = name
      self.amount = amount
      self.recurrence = recurrence
      self.targetDate = targetDate
    }
  }
}
