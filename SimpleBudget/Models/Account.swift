import SwiftData
import SwiftUI

@Model
class Account {
    var name: String
    var balance: Decimal
    var isDebt: Bool

    init() {
        name = ""
        balance = 0
        isDebt = false
    }
}
