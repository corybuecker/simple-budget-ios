import SwiftData
import SwiftUI

struct EnvelopeDetail: View {
    @Bindable var envelope: Envelope

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            TextField("Name", text: $envelope.name)
            TextField("Amount", value: $envelope.amount, format: .number)
                .keyboardType(.decimalPad)
        }
        .navigationTitle(envelope.name)
        .toolbar {
            Button("Save") {
                try? modelContext.save()
                dismiss()
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Envelope.self, configurations: config)
    let sample = Envelope()

    sample.name = "Groceries"
    sample.amount = 500

    container.mainContext.insert(sample)

    return NavigationStack {
        EnvelopeDetail(envelope: sample)
    }
    .modelContainer(container)
}
