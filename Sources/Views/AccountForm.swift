import SwiftData
import SwiftUI

struct AccountForm: View {
  let account: Account?

  enum FocusedField: Hashable {
    case name, balance
  }

  @State private var name: String = ""
  @State private var balance: Double?
  @State private var debt: Bool = false
  @FocusState private var focusedField: FocusedField?

  @Environment(\.modelContext) var modelContext: ModelContext
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    Form {
      ZStack(alignment: .trailing) {
        TextField("Name", text: $name).focused($focusedField, equals: .name)

        if focusedField == .name {
          Spacer()
          Button {
            name = ""
          } label: {
            Image(systemName: "xmark.circle.fill")
              .foregroundColor(.gray)
          }
        }
      }
      ZStack(alignment: .trailing) {
        TextField("Balance", value: $balance, format: .currency(code: "USD")).focused(
          $focusedField, equals: .balance
        ).keyboardType(.decimalPad)

        if focusedField == .balance {
          Spacer()
          Button {
            balance = nil
          } label: {
            Image(systemName: "xmark.circle.fill")
              .foregroundColor(.gray)
          }
        }
      }
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
        Button("Save", action: save)
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

  func save() {
    if let account {
      account.name = name
      account.balance = balance ?? 0
      account.debt = debt
    } else {
      modelContext.insert(Account(name: name, balance: balance ?? 0, debt: debt))
    }

    dismiss()
  }
}
