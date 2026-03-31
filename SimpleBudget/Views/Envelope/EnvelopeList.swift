import SwiftData
import SwiftUI

struct EnvelopeList: View {
    @Query var envelopes: [Envelope]
    @Environment(\.modelContext) private var modelContext

    @State private var path: NavigationPath = .init()

    enum Route: Hashable {
        case existingEnvelope(envelope: Envelope)
        case newEnvelope
    }

    var body: some View {
        NavigationStack(path: $path) {
            List(envelopes) { envelope in
                NavigationLink(value: Route.existingEnvelope(envelope: envelope)) {
                    Text("\(envelope.name) \(envelope.amount, format: .currency(code: "USD").precision(.fractionLength(0)))")
                }.swipeActions(edge: .trailing) {
                    Button("Delete") {
                        modelContext.delete(envelope)
                    }
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case let .existingEnvelope(envelope):
                    EnvelopeDetail(envelope: envelope)
                case .newEnvelope:
                    EnvelopeCreate()
                }
            }
            .navigationTitle("Envelopes")
            .toolbar {
                Button(action: addEnvelope) {
                    Label("Add envelope", systemImage: "plus")
                }
            }
        }
    }

    private func addEnvelope() {
        path.append(Route.newEnvelope)
    }
}

#Preview {
    let container: ModelContainer = {
        let container = try! ModelContainer(
            for: Envelope.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )

        let sampleEnvelopes = [
            ("Groceries", Decimal(400)),
            ("Entertainment", Decimal(150)),
            ("Transportation", Decimal(200)),
        ]

        for (name, amount) in sampleEnvelopes {
            let envelope = Envelope()
            envelope.name = name
            envelope.amount = amount
            container.mainContext.insert(envelope)
        }

        return container
    }()

    EnvelopeList()
        .modelContainer(container)
}
