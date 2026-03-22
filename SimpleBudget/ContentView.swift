import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            
            Tab("Accounts", systemImage: "dollarsign") {
                Text("test")
            }
            Tab("Envelopes", systemImage: "dollarsign") {
                Text("test")
            }
            Tab("Goals", systemImage: "dollarsign") {
                Text("test")
            }
        }
    }
}

#Preview {
    ContentView()
}
