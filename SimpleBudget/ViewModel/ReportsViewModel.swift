import FinanceKit
import SwiftUI

protocol FinanceStoreProviding {
    func accountBalances(query: AccountBalanceQuery) async throws -> [AccountBalance]
    func requestAuthorization() async throws -> FinanceKit.AuthorizationStatus
}

extension FinanceStore: FinanceStoreProviding {}

struct MockFinanceStore: FinanceStoreProviding {
    func requestAuthorization() async throws -> AuthorizationStatus {
        .authorized
    }

    func accountBalances(query _: AccountBalanceQuery) async throws -> [AccountBalance] {
        []
    }
}

struct WrappedAccountBalance: Identifiable {
    let id = UUID()
    var accountName: String
    var balance: Decimal
}

@Observable
class ReportsViewModel {
    var financePermissionStatus: FinanceKit.AuthorizationStatus?
    var wrappedBalances: [WrappedAccountBalance] = []

    @ObservationIgnored
    private var store: FinanceStoreProviding

    @ObservationIgnored
    private var isUsingFinanceStore: Bool

    init(store: FinanceStoreProviding? = nil) {
        isUsingFinanceStore = store == nil
        self.store = store ?? FinanceStore.shared
    }

    func refreshAccountBalances() async throws {
        if isUsingFinanceStore {
            let accountsBalances = try await store.accountBalances(query: AccountBalanceQuery())

            wrappedBalances = accountsBalances.map { balance in
                WrappedAccountBalance(
                    accountName: balance.accountID.uuidString,
                    balance: balance.booked?.amount.amount ?? 0
                )
            }
        }
    }

    func requestAccess() async throws {
        if financePermissionStatus == .authorized {
            return
        }

        let response = try await store.requestAuthorization()

        switch response {
        case .authorized:
            financePermissionStatus = .authorized
        case .denied:
            break
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
}
