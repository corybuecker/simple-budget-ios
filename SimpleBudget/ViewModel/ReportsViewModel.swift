import FinanceKit
import os
import SwiftUI

protocol FinanceStoreProviding {
    func accountBalances(query: AccountBalanceQuery) async throws -> [AccountBalance]
    func accounts(query: AccountQuery) async throws -> [FinanceKit.Account]
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

    func accounts(query _: AccountQuery) async throws -> [FinanceKit.Account] {
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

    let logger = Logger(subsystem: "dev.bueckered.simple-budget", category: "ReportViewModel")

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
            let accounts = try await store.accounts(query: AccountQuery())
            let query = AccountBalanceQuery.predicate(availableSince: Date().addingTimeInterval(-86400))
            let accountsBalances = try await store.accountBalances(query: AccountBalanceQuery(predicate: query))

            for accountsBalance in accountsBalances {
                switch accountsBalance.currentBalance {
                case let .available(balance):
                    logger.debug("Available -> \(accountsBalance.accountID) - \(balance.amount.amount)")
                case let .booked(balance):
                    logger.debug("Booked -> \(accountsBalance.accountID) - \(balance.amount.amount)")
                case let .availableAndBooked(_, booked):
                    logger.debug("Available and booked -> \(accountsBalance.accountID) - \(booked.amount.amount)")
                @unknown default:
                    logger.error("not implemented")
                }
            }

            wrappedBalances = accounts.map { account in
                let currentBalance = accountsBalances.first(where: { balance in
                    balance.accountID == account.id
                })

                return WrappedAccountBalance(
                    accountName: account.displayName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
                    balance: currentBalance?.booked?.amount.amount ?? 0
                )
            }
        }
    }

    @MainActor
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
