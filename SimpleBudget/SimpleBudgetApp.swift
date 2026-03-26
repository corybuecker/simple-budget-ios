import SwiftUI

@main
struct SimpleBudgetApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Account.self])
    }
}
