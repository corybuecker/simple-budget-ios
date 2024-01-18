import SwiftData
import SwiftUI

struct GoalForm: View {
  let goal: Goal?

  @State private var name: String = ""
  @State private var amount: Double = 0.0
  @State private var recurrence: GoalRecurrence = .monthly
  @State private var targetDate: Date = Date()

  @Environment(\.modelContext) var modelContext: ModelContext
  @Environment(\.dismiss) var dismiss

  private var numberFormatter: NumberFormatter {
    let f = NumberFormatter()
    f.zeroSymbol = ""
    return f
  }

  var body: some View {
    Form {
      TextField("Name", text: $name)
      TextField("Amount", value: $amount, formatter: numberFormatter)
      Picker("Recurrance", selection: $recurrence) {
        Text("Daily").tag(GoalRecurrence.daily)
        Text("Weekly").tag(GoalRecurrence.weekly)
        Text("Monthly").tag(GoalRecurrence.monthly)
        Text("Yearly").tag(GoalRecurrence.yearly)
      }
      DatePicker("Target Date", selection: $targetDate, displayedComponents: [.date])
    }
    .navigationBarTitle(goal?.name ?? "New Goal")
    .navigationBarBackButtonHidden()
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button {
          dismiss()
        } label: {
          Image(systemName: "x.circle.fill")
        }
        .tint(.gray)
      }
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("Save") {
          let startOfDay = Calendar.current.startOfDay(for: targetDate)

          if let goal = goal {
            goal.name = name
            goal.amount = amount
            goal.recurrence = recurrence
            goal.targetDate = startOfDay
          } else {
            modelContext.insert(
              Goal(name: name, amount: amount, recurrence: recurrence, targetDate: startOfDay))
          }

          dismiss()
        }
      }
    }.onAppear {
      if let goal {
        name = goal.name
        amount = goal.amount
        recurrence = goal.recurrence
        targetDate = goal.targetDate
      }
    }
  }
}
