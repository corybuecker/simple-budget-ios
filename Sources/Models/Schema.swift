import SwiftData

struct SchemaV102: VersionedSchema {
  static var versionIdentifier: Schema.Version = Schema.Version(1, 0, 2)
  static var models: [any PersistentModel.Type] = [
    AccountV102.Account.self, EnvelopeV102.Envelope.self, GoalV102.Goal.self,
  ]
}
