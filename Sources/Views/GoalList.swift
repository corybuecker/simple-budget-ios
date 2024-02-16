import SwiftData
import SwiftUI

struct GoalList: View {
  @Environment(\.modelContext) var modelContext: ModelContext
  @Query<Goal>(sort: [SortDescriptor<Goal>(\.targetDate)]) private var goals: [Goal]

  @State private var lastRendered: Date = Date()

  var body: some View {
    NavigationStack {
      List {
        ForEach(goals, id: \.self) { goal in
          GoalListItem(goal: goal, lastRendered: lastRendered)
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

  private var gradientDistance: Decimal {
    let amortized = GoalService(goal: goal).amortized()

    return amortized / Decimal(goal.amount)
  }

  var body: some View {
    NavigationLink(destination: GoalForm(goal: goal)) {
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
        .foregroundStyle(.secondary)
      }
    }
    //    .listRowBackground(
    //      LinearGradient(
    //        stops: [
    //          Gradient.Stop(
    //            color: .gray.opacity(0.01),
    //            location: NSDecimalNumber(decimal: gradientDistance).doubleValue),
    //          Gradient.Stop(
    //            color: .white, location: NSDecimalNumber(decimal: gradientDistance).doubleValue),
    //        ], startPoint: .topLeading, endPoint: .bottomTrailing)
    //    )
  }
}
