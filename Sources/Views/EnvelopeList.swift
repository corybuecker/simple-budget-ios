import SwiftData
import SwiftUI

struct EnvelopeList: View {
  @Environment(\.modelContext) var modelContext: ModelContext
  @Query<Envelope> private var envelopes: [Envelope]

  var body: some View {
    NavigationStack {
      List {
        ForEach(envelopes, id: \.self) { envelope in
          NavigationLink(destination: EnvelopeForm(envelope: envelope)) {
            Text(envelope.name)
          }
        }.onDelete(perform: deleteEnvelope)
      }
      .navigationBarTitle("Envelopes")
      .toolbar {
        ToolbarItem {
          NavigationLink(destination: EnvelopeForm(envelope: nil)) {
            Image(systemName: "plus")
          }
        }
      }
    }
  }

  func deleteEnvelope(at offsets: IndexSet) {
    for offset in offsets {
      modelContext.delete(envelopes[offset])
    }
  }
}
