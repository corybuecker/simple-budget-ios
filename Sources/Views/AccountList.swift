import SwiftData
import SwiftUI

struct AccountList: View {
  @Environment(\.modelContext) var modelContext: ModelContext
  @Query<Account> private var accounts: [Account]

  var body: some View {
    VStack {
      NavigationStack {
        List {
          ForEach(accounts, id: \.self) { account in
            NavigationLink(destination: AccountForm(account: account)) {
              Text(account.name)
            }
          }.onDelete(perform: deleteAccount)
        }.navigationBarTitle("Accounts").toolbar {
          ToolbarItem {
            NavigationLink(destination: AccountForm(account: nil)) {
              Image(systemName: "plus")
            }
          }
        }
      }
      Spacer()
    }
  }

  func deleteAccount(at offsets: IndexSet) {
    for offset in offsets {
      modelContext.delete(accounts[offset])
    }
  }
}
