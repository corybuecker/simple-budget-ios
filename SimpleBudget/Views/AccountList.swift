import SwiftData
import SwiftUI

struct AccountList: View {
    @Query var accounts: [Account]
    @Environment(\.modelContext) private var modelContext

    @State private var path: NavigationPath = NavigationPath()
    
    enum Route: Hashable {
        case existingAccount(account: Account)
        case newAccount(account: Account)
    }

    var body: some View {
        NavigationStack(path: $path) {
            List(accounts) { account in
                NavigationLink(value: Route.existingAccount(account: account)) {
                    if account.isDebt {
                        Text("\(account.name) (\(account.balance, format: .currency(code: "USD").precision(.fractionLength(0))))").foregroundColor(.red)
                    } else {
                        Text("\(account.name) \(account.balance, format: .currency(code: "USD").precision(.fractionLength(0)))")
                    }
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .existingAccount(let account):
                    AccountDetail(account: account, isNew: false)
                case .newAccount(let account):
                    AccountDetail(account: account, isNew: true)
                }
            }
            .navigationTitle("Accounts")
            .toolbar {
                Button(action: addAccount) {
                    Label("Add account", systemImage: "plus")
                }
            }
        }
    }

    private func addAccount() {
        let account = Account()
        account.name = "New Account"
        modelContext.insert(account)
        path.append(Route.newAccount(account: account))
    }
}

#Preview {
    let container: ModelContainer = {
        let container = try! ModelContainer(
            for: Account.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )

        let sampleAccounts = [
            ("Checking", Decimal(1500.50), false),
            ("Savings", Decimal(10000.00), false),
            ("Credit Card", Decimal(250.7512), true),
        ]

        for (name, balance, isDebt) in sampleAccounts {
            let account = Account()
            account.name = name
            account.balance = balance
            account.isDebt = isDebt
            container.mainContext.insert(account)
        }

        return container
    }()

    AccountList()
        .modelContainer(container)
}
