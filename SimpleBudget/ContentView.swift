import SwiftUI

struct ContentView: View {
    @State private var selectedTab: TabItem = .accounts

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Accounts", systemImage: "dollarsign.bank.building", value: .accounts) {
                AccountList()
            }
            Tab("Envelopes", systemImage: "envelope", value: .envelopes) {
                Envelops()
            }
            Tab("Goals", systemImage: "chart.pie", value: .goals) {
                Goals()
            }
            Tab("Reports", systemImage: "dollarsign.gauge.chart.lefthalf.righthalf", value: .reports) {
                Reports()
            }
        }
    }

    private enum TabItem {
        case accounts
        case goals
        case envelopes
        case reports
    }
}

#Preview {
    ContentView()
}
