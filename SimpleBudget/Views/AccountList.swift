import SwiftData
import SwiftUI

struct AccountList: View {
    @Query var accounts: [Account]

    var body: some View {
        NavigationStack {
            List(accounts) { account in
                NavigationLink(destination: AccountDetail(account: account)) {
                    Text(account.name)
                }
            }
            .navigationTitle("Accounts")
        }
    }
}

#Preview {
    let container: ModelContainer = {
        let container = try! ModelContainer(
            for: Account.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )

        let sampleAccounts = [
            ("Checking", Decimal(1500.50)),
            ("Savings", Decimal(10000.00)),
            ("Credit Card", Decimal(-250.75)),
        ]

        for (name, balance) in sampleAccounts {
            let account = Account()
            account.name = name
            account.balance = balance
            container.mainContext.insert(account)
        }

        return container
    }()

    AccountList()
        .modelContainer(container)
}
