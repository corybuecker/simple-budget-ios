import SwiftData
import SwiftUI

struct GoalList: View {
    static var goalsSortedByTargetDate: FetchDescriptor<Goal> = .init(sortBy: [SortDescriptor<Goal>(\Goal.targetDate)])
    @Query(goalsSortedByTargetDate) var goals: [Goal]

    @Environment(\.modelContext) private var modelContext

    @State private var path: NavigationPath = .init()

    enum Route: Hashable {
        case existingGoal(goal: Goal)
        case newGoal
    }

    private var progressByGoal: [Goal.ID: Double] {
        let reportService = ReportService(accounts: [], envelopes: [], goals: goals)

        do {
            return try reportService.progressByGoal()
        } catch {
            return [:]
        }
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
                        if let progressByGoalValue = progressByGoal[goal.id] {
                            if progressByGoalValue > 0 {
                                GeometryReader { geometry in
                                    Rectangle()
                                        .fill(Color.green)
                                        .frame(width: geometry.size.width * progressByGoalValue, height: 3)
                                }
                            }
                        }
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
            ("Last Vacation", Decimal(2000), Recurrence.monthly, Date().advanced(by: TimeInterval(15_500_000))),
            ("Vacation", Decimal(2000), Recurrence.yearly, Date()),
            ("Emergency Fund", Decimal(500), Recurrence.monthly, Date().advanced(by: TimeInterval(1_500_000))),
            ("New Car", Decimal(5000), Recurrence.yearly, Date()),
        ]

        for (name, amount, recurrence, targetDate) in sampleGoals {
            let goal = Goal()
            goal.name = name
            goal.amount = amount
            goal.recurrence = recurrence
            goal.targetDate = targetDate
            container.mainContext.insert(goal)
        }

        return container
    }()

    GoalList()
        .modelContainer(container)
}
