import SwiftData
import SwiftUI

struct GoalForm: View {
  let goal: Goal?

  enum FocusedField {
    case name, amount
  }

  @State private var name: String = ""
  @State private var amount: Double?
  @State private var recurrence: GoalRecurrence = .monthly
  @State private var targetDate: Date = Date()

  @FocusState private var focusedField: FocusedField?

  @Environment(\.modelContext) var modelContext: ModelContext
  @Environment(\.dismiss) var dismiss

  var body: some View {
    Form {
      ZStack(alignment: .trailing) {
        TextField("Name", text: $name).focused($focusedField, equals: .name)
        if focusedField == .name {
          Spacer()
          Button {
            name = ""
          } label: {
            Image(systemName: "xmark.circle.fill")
              .foregroundColor(.gray)
          }
        }
      }

      ZStack(alignment: .trailing) {
        TextField(
          "Amount", value: $amount,
          format: .currency(code: Locale.current.currency?.identifier ?? "USD")
        )
        .focused($focusedField, equals: .amount)
        if focusedField == .amount {
          Spacer()
          Button {
            amount = nil
          } label: {
            Image(systemName: "xmark.circle.fill")
              .foregroundColor(.gray)
          }
        }
      }

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
        Button("Save", action: save)

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

  func save() {
    let startOfDay = Calendar.current.startOfDay(for: targetDate)

    if let goal = goal {
      goal.name = name
      goal.amount = amount ?? 0
      goal.recurrence = recurrence
      goal.targetDate = startOfDay
    } else {
      modelContext.insert(
        Goal(name: name, amount: amount ?? 0, recurrence: recurrence, targetDate: startOfDay))
    }

    dismiss()
  }
}
