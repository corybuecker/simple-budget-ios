import SwiftData
import SwiftUI

struct GoalCreate: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var amount: Decimal?
    @State private var targetDate: Date = .init()
    @State private var startDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()

    @State private var recurrence: Recurrence = .monthly

    var body: some View {
        Form {
            TextField("Name", text: $name)
            TextField("Amount", value: $amount, format: .number)
                .keyboardType(.decimalPad)
            DatePicker("Target Date", selection: $targetDate, displayedComponents: .date)
            Picker("Recurrence", selection: $recurrence) {
                ForEach(Recurrence.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value)
                }
            }
            if recurrence == .never {
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
            }
        }
        .navigationTitle("New Goal")
        .toolbar {
            Button("Save") {
                let goal = Goal()
                goal.name = name
                if let amount {
                    goal.amount = amount
                }
                goal.targetDate = targetDate
                goal.recurrence = recurrence

                if recurrence == .never {
                    goal.startDate = startDate
                } else {
                    goal.startDate = nil
                }

                modelContext.insert(goal)
                dismiss()
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Goal.self, configurations: config)

    return NavigationStack {
        GoalCreate()
    }
    .modelContainer(container)
}
