import SwiftData
import SwiftUI

struct ContentView: View {
  @Environment(\.modelContext) var context: ModelContext

  var body: some View {
    TabView {
      Reports()
        .tabItem {
          Label("Reports", systemImage: "chart.bar")
        }
      AccountList()
        .tabItem {
          Label("Accounts", systemImage: "building.columns")
        }
      EnvelopeList()
        .tabItem {
          Label("Envelopes", systemImage: "envelope")
        }
      GoalList()
        .tabItem {
          Label("Goals", systemImage: "target")
        }
    }
  }
}
