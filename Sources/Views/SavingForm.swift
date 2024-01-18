import SwiftData
import SwiftUI

struct SavingForm: View {
  let saving: Saving?

  @State private var name: String = ""
  @State private var amount: Double = 0.0

  @Environment(\.modelContext) var modelContext: ModelContext
  @Environment(\.dismiss) var dismiss

  private var numberFormatter: NumberFormatter {
    let f = NumberFormatter()
    f.zeroSymbol = ""
    return f
  }

  var body: some View {
    Form {
      TextField("Name", text: $name)
      TextField("Amount", value: $amount, formatter: numberFormatter)
    }
    .navigationBarTitle(saving?.name ?? "New Saving")
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
          if let saving = saving {
            saving.name = name
            saving.amount = amount
          } else {
            modelContext.insert(Saving(name: name, amount: amount))
          }

          dismiss()
        }
      }
    }.onAppear {
      if let saving {
        name = saving.name
        amount = saving.amount
      }
    }
  }
}
