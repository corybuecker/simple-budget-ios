import SwiftData
import SwiftUI

struct EnvelopeForm: View {
  let envelope: Envelope?

  enum FocusedField {
    case name, amount
  }

  @State private var name: String = ""
  @State private var amount: Double?

  @FocusState private var focusedField: FocusedField?

  @Environment(\.modelContext) var modelContext: ModelContext
  @Environment(\.dismiss) var dismiss

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
        TextField(
          "Amount", value: $amount,
          format: .currency(code: Locale.current.currency?.identifier ?? "USD")
        ).focused($focusedField, equals: .amount).keyboardType(.decimalPad)

        if focusedField == .amount {
          Spacer()
          Button {
            amount = nil
          } label: {
            Image(systemName: "xmark.circle.fill")
              .foregroundColor(.gray)
          }
        }

      }
    }
    .navigationBarTitle(envelope?.name ?? "New Envelope")
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
    }.onAppear {
      if let envelope {
        name = envelope.name
        amount = envelope.amount
      }
    }
  }

  private func save() {
    if let envelope = envelope {
      envelope.name = name
      envelope.amount = amount ?? 0
    } else {
      modelContext.insert(Envelope(name: name, amount: amount ?? 0))
    }

    dismiss()
  }
}
