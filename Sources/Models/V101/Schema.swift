import SwiftData

struct SchemaV101: VersionedSchema {
  static var versionIdentifier: Schema.Version = Schema.Version(1, 0, 1)
  static var models: [any PersistentModel.Type] = [
    AccountV101.Account.self, SavingV101.Saving.self, GoalV101.Goal.self,
  ]
}
