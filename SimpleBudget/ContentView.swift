import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 3
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Accounts", systemImage: "dollarsign.bank.building", value: 0) {
                Accounts()
            }
            Tab("Envelopes", systemImage: "envelope", value: 1) {
                Envelops()
            }
            Tab("Goals", systemImage: "chart.pie", value: 2) {
                Goals()
            }
            Tab("Reports", systemImage: "dollarsign.gauge.chart.lefthalf.righthalf", value: 3) {
                Reports()
            }
        }
    }
}

#Preview {
    ContentView()
}
