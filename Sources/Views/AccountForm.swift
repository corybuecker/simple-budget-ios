import SwiftData
import SwiftUI

struct AccountForm: View {
  let account: Account?

  @State private var name: String = ""
  @State private var balance: Double = 0.0
  @State private var debt: Bool = false

  @Environment(\.modelContext) var modelContext: ModelContext
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    Form {
      TextField("Name", text: $name)
      TextField("Balance", value: $balance, format: .currency(code: "USD"))
      Section("Debt?") {
        Picker("Debt", selection: $debt) {
          Text("No").tag(false)
          Text("Yes").tag(true)
        }
        .pickerStyle(.segmented)
      }
    }
    .navigationBarTitle(account?.name ?? "New Account")
    .navigationBarBackButtonHidden()
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button {
          dismiss()
        } label: {
          Image(systemName: "x.circle.fill")
        }
        .tint(.gray)
      }
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("Save") {
          if let account {
            account.name = name
            account.balance = balance
            account.debt = debt
          } else {
            modelContext.insert(Account(name: name, balance: balance, debt: debt))
          }
          dismiss()
        }
      }
    }
    .onAppear {
      if let account {
        name = account.name
        balance = account.balance
        debt = account.debt
      }
    }
  }
}
