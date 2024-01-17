import SwiftData
import SwiftUI

@main
struct SimpleBudget: App {
  var body: some Scene {
    WindowGroup {
      ContentView().modelContainer(for: [Account.self, Saving.self, Goal.self])
    }
  }
}
