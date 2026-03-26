
import SwiftUI

struct AccountDetail: View {
    init(account _: Account) {}

    @State private var name: String = ""
    @State private var amount: Decimal?

    var body: some View {
        Form {
            Section("Account Details") {
                TextField("Name", text: $name)
                TextField("Amount", value: $amount, format: .number)
                    .keyboardType(.decimalPad)
            }
        }
        .navigationTitle("Accounts")
    }
}

#Preview {
    var account = Account()
    AccountDetail(account: account)
}
