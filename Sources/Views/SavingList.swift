import SwiftData
import SwiftUI

struct SavingList: View {
  @Environment(\.modelContext) var modelContext: ModelContext
  @Query<Saving> private var savings: [Saving]

  var body: some View {
    VStack {
      NavigationStack {
        List {
          ForEach(savings, id: \.self) { saving in
            NavigationLink(destination: SavingForm(saving: saving)) {
              Text(saving.name)
            }
          }.onDelete(perform: deleteSaving)
        }.navigationBarTitle("Savings").toolbar {
          ToolbarItem {
            NavigationLink(destination: SavingForm(saving: nil)) {
              Image(systemName: "plus")
            }
          }
        }
      }
      Spacer()
    }
  }

  func deleteSaving(at offsets: IndexSet) {
    for offset in offsets {
      modelContext.delete(savings[offset])
    }
  }
}
