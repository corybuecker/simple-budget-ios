import SwiftData
import SwiftUI

struct GoalList: View {
  @Environment(\.modelContext) var modelContext: ModelContext
  @Query<Goal> private var goals: [Goal]

  @State private var lastRendered: Date = Date()

  var body: some View {
    VStack {
      NavigationStack {
        List {
          ForEach(goals, id: \.self) { goal in
            NavigationLink(destination: GoalForm(goal: goal)) {
              GoalListItem(goal: goal, lastRendered: lastRendered)
            }
          }
          .onDelete(perform: deleteGoal)
        }
        .navigationBarTitle("Goals")
        .toolbar {
          ToolbarItem {
            NavigationLink(destination: GoalForm(goal: nil)) {
              Image(systemName: "plus")
            }
          }
        }
        .refreshable {
          lastRendered = Date()
        }
      }
      Spacer()
    }
  }

  func deleteGoal(at offsets: IndexSet) {
    for offset in offsets {
      modelContext.delete(goals[offset])
    }
  }
}

struct GoalListItem: View {
  let goal: Goal
  let lastRendered: Date

  var body: some View {
    VStack(alignment: .leading) {
      Text(goal.name)
      Text(goal.targetDate.formatted(date: .abbreviated, time: .omitted))
        .foregroundColor(.secondary)
      HStack {
        Text(
          GoalService(goal: goal).dailyAmount(),
          format: .currency(code: "USD").precision(.fractionLength(2)))
        Text("/")
        Text(
          GoalService(goal: goal).amortized(),
          format: .currency(code: "USD").precision(.fractionLength(5)))
        Text("/")
        Text(goal.amount, format: .currency(code: "USD").precision(.fractionLength(0)))
      }
      .foregroundColor(.secondary)
    }
  }
}
