import SwiftData
import SwiftUI

struct GoalDetail: View {
    @Bindable var goal: Goal

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            TextField("Name", text: $goal.name)
            TextField("Amount", value: $goal.amount, format: .number)
                .keyboardType(.decimalPad)
            DatePicker("Target Date", selection: $goal.targetDate, displayedComponents: .date)
            Picker("Recurrence", selection: $goal.recurrence) {
                ForEach(Recurrence.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value)
                }
            }
        }
        .navigationTitle(goal.name)
        .toolbar {
            Button("Save") {
                try? modelContext.save()
                dismiss()
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Goal.self, configurations: config)
    let sample = Goal()

    sample.name = "Vacation"
    sample.amount = 2000
    sample.recurrence = .yearly

    container.mainContext.insert(sample)

    return NavigationStack {
        GoalDetail(goal: sample)
    }
    .modelContainer(container)
}
