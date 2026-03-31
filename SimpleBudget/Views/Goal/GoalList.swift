import SwiftData
import SwiftUI

struct GoalList: View {
    @Query var goals: [Goal]
    @Environment(\.modelContext) private var modelContext

    @State private var path: NavigationPath = .init()

    enum Route: Hashable {
        case existingGoal(goal: Goal)
        case newGoal
    }

    var body: some View {
        NavigationStack(path: $path) {
            List(goals) { goal in
                NavigationLink(value: Route.existingGoal(goal: goal)) {
                    VStack(alignment: .leading) {
                        Text("\(goal.name) - \(goal.amount, format: .currency(code: "USD").precision(.fractionLength(0)))")
                        Text("\(goal.recurrence.rawValue) · \(goal.targetDate, format: .dateTime.month().day().year())")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .swipeActions(edge: .trailing) {
                    Button("Delete") {
                        modelContext.delete(goal)
                    }
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case let .existingGoal(goal):
                    GoalDetail(goal: goal)
                case .newGoal:
                    GoalCreate()
                }
            }
            .navigationTitle("Goals")
            .toolbar {
                Button(action: addGoal) {
                    Label("Add goal", systemImage: "plus")
                }
            }
        }
    }

    private func addGoal() {
        path.append(Route.newGoal)
    }
}

#Preview {
    let container: ModelContainer = {
        let container = try! ModelContainer(
            for: Goal.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )

        let sampleGoals = [
            ("Vacation", Decimal(2000), Recurrence.yearly),
            ("Emergency Fund", Decimal(500), Recurrence.monthly),
            ("New Car", Decimal(5000), Recurrence.yearly),
        ]

        for (name, amount, recurrence) in sampleGoals {
            let goal = Goal()
            goal.name = name
            goal.amount = amount
            goal.recurrence = recurrence
            container.mainContext.insert(goal)
        }

        return container
    }()

    GoalList()
        .modelContainer(container)
}
