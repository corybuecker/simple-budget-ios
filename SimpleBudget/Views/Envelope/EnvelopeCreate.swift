import SwiftData
import SwiftUI

struct EnvelopeCreate: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var amount: Decimal?

    var body: some View {
        Form {
            TextField("Name", text: $name)
            TextField("Amount", value: $amount, format: .number)
                .keyboardType(.decimalPad)
        }
        .navigationTitle("New Envelope")
        .toolbar {
            Button("Save") {
                let envelope = Envelope()
                envelope.name = name
                if let amount {
                    envelope.amount = amount
                }

                modelContext.insert(envelope)
                dismiss()
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Envelope.self, configurations: config)

    return NavigationStack {
        EnvelopeCreate()
    }
    .modelContainer(container)
}
