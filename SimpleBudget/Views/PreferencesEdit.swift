import SwiftData
import SwiftUI

struct PreferencesEdit: View {
    @Environment(\.modelContext) private var context
    var preferences: Preferences {
        Preferences.fetch(context: context)
    }

    var body: some View {
        PreferencesForm(preferences: preferences)
    }
}

struct PreferencesForm: View {
    @Bindable var preferences: Preferences

    var body: some View {
        Form {
            TextField("Apple Card installments",
                      value: $preferences.appleCardInstallments,
                      format: .number)
            TextField("Monthly income",
                      value: $preferences.monthlyIncome,
                      format: .number)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Preferences.self, configurations: config)

    NavigationStack {
        PreferencesEdit()
    }
    .modelContainer(container)
}
