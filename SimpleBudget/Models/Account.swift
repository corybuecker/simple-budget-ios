import SwiftData
import SwiftUI

@Model
class Account {
    var name: String
    var balance: Decimal

    init() {
        name = ""
        balance = 0
    }
}
