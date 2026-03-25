import SwiftData
import SwiftUI

struct AccountCreate: View {
    @Environment(\.modelContext) private var modelContext

    ///    private var _dismiss: Environment<DismissAction> = Environment(\.dismiss)
    ///    private var dismiss: DismissAction { _dismiss.wrappedValue }
    @Environment(\.dismiss) private var dismiss: DismissAction

    @State private var name: String = ""
    @State private var balance: Decimal?
    @State private var isDebt: Bool = false

    var body: some View {
        Form {
            TextField("Name", text: $name)
            TextField("Amount", value: $balance, format: .number)
                .keyboardType(.decimalPad)
            Toggle("Debt?", isOn: $isDebt)
        }
        .navigationTitle("New Account")
        .toolbar {
            Button("Save") {
                let account = Account()
                account.name = name
                if let balance {
                    account.balance = balance
                }
                account.isDebt = isDebt

                modelContext.insert(account)
                dismiss()
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Account.self, configurations: config)

    return NavigationStack {
        AccountCreate()
    }
    .modelContainer(container)
}
