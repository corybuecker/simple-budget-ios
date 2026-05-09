import SwiftData
import SwiftUI

struct SimpleBudgetSchemaV110: VersionedSchema {
    static let models: [any PersistentModel.Type] = [Account.self,
                                                     Envelope.self,
                                                     Goal.self, Preferences.self]

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

    @Model class Preferences {
        var monthlyIncome: Decimal?
        var appleCardInstallments: Decimal?

        init() {
            monthlyIncome = nil
            appleCardInstallments = nil
        }

        static func fetch(context: ModelContext) -> Preferences {
            do {
                let results = try context.fetch(FetchDescriptor<Preferences>())

                if let existing = results.first {
                    return existing
                }

                let new = Preferences()
                context.insert(new)
                return new
            } catch {
                let new = Preferences()
                context.insert(new)
                return new
            }
        }
    }
}

typealias Account = SimpleBudgetSchemaV110.Account
typealias Envelope = SimpleBudgetSchemaV110.Envelope
typealias Goal = SimpleBudgetSchemaV110.Goal
typealias Recurrence = SimpleBudgetSchemaV110.Recurrence
typealias Preferences = SimpleBudgetSchemaV110.Preferences

enum SimpleBudgetSchemaV110MigrationPlan: SchemaMigrationPlan {
    static let schemas: [any VersionedSchema.Type] = [SimpleBudgetSchemaV110.self]

    static let stages: [MigrationStage] = []
}
