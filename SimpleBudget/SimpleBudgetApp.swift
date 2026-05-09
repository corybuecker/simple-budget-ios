import FinanceKit
import SwiftData
import SwiftUI

@main
struct SimpleBudgetApp: App {
    var modelContainer: ModelContainer = try! ModelContainer(for: Schema(versionedSchema: SimpleBudgetSchemaV110.self),
                                                             migrationPlan: SimpleBudgetSchemaV110MigrationPlan.self)

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
