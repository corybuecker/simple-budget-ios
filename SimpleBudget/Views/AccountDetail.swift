import SwiftData
import SwiftUI

struct AccountDetail: View {
    @Bindable var account: Account
    let isNew: Bool
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            TextField("Name", text: $account.name)
            TextField("Amount", value: $account.balance, format: .number)
                .keyboardType(.decimalPad)
            Toggle("Debt?", isOn: $account.isDebt)
        }
        .navigationTitle(account.name)
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
    let container = try! ModelContainer(for: Account.self, configurations: config)
    let sample = Account()

    sample.name = "Checking"
    sample.balance = 1000
    sample.isDebt = false

    container.mainContext.insert(sample)

    return NavigationStack {
        AccountDetail(account: sample, isNew: true)
    }
    .modelContainer(container)
}
