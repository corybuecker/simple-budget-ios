import SwiftData
import SwiftUI

struct SimpleBudgetSchemaV100: VersionedSchema {
    static let models: [any PersistentModel.Type] = [Account.self,
                                                     Envelope.self,
                                                     Goal.self]

    static let versionIdentifier: Schema.Version = .init(1, 0, 0)

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

    @Model
    class Envelope {
        var name: String
        var amount: Decimal

        init() {
            name = ""
            amount = 0
        }
    }

    enum Recurrence: String, Codable, CaseIterable {
        case monthly = "Monthly"
        case yearly = "Yearly"
        case never = "Never"
    }

    @Model
    class Goal {
        var name: String
        var amount: Decimal
        var targetDate: Date
        var startDate: Date?
        var recurrence: Recurrence

        init() {
            name = ""
            amount = 0
            targetDate = Date()
            recurrence = .monthly
        }
    }
}

typealias Account = SimpleBudgetSchemaV100.Account
typealias Envelope = SimpleBudgetSchemaV100.Envelope
typealias Goal = SimpleBudgetSchemaV100.Goal
typealias Recurrence = SimpleBudgetSchemaV100.Recurrence

enum SimpleBudgetSchemaV100MigrationPlan: SchemaMigrationPlan {
    static let schemas: [any VersionedSchema.Type] = [SimpleBudgetSchemaV100.self]

    static let stages: [MigrationStage] = []
}
