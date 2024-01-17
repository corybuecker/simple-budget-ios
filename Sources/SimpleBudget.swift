import SwiftData
import SwiftUI

@main
struct SimpleBudget: App {
  let modelContainer: ModelContainer

  init() {
    let schema: Schema = Schema(versionedSchema: SchemaV101.self)
    modelContainer = try! ModelContainer(for: schema)
  }

  var body: some Scene {
    WindowGroup {
      ContentView().modelContainer(modelContainer)
    }
  }
}
