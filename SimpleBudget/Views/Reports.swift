import SwiftData
import SwiftUI

struct Reports: View {
    //            private var _accounts = Query<Account, [Account]>()
    //
    //            private var accounts: [Account] {
    //                @storageRestrictions(initializes: _accounts)
    //                init(initialValue) {
    //                    _accounts = Query<Account, [Account]>()
    //                }
    //
    //               get {
    //                    _accounts.wrappedValue
    //                }
    //            }
    @Query private var accounts: [Account]

    @Query private var envelopes: [Envelope]
    @Query private var goals: [Goal]

    @State private var reportsViewModel: ReportsViewModel

    init(viewModel: ReportsViewModel?) {
        reportsViewModel = viewModel ?? ReportsViewModel()
    }

    private var remaining: Decimal {
        let reportService = ReportService(accounts: accounts, envelopes: envelopes, goals: goals)

        do {
            return try reportService.remaining()
        } catch {
            return 0
        }
    }

    private var remainingTime: Decimal {
        let reportService = ReportService(accounts: accounts, envelopes: envelopes, goals: goals)

        do {
            return try reportService.remainingTime()
        } catch {
            return 0
        }
    }

    private var remainingPerDay: Decimal {
        let reportService = ReportService(accounts: accounts, envelopes: envelopes, goals: goals)

        do {
            return try reportService.remainingPerDay()
        } catch {
            return 0
        }
    }

    var body: some View {
        VStack {
            Text(remaining, format: .currency(code: Locale.current.currency?.identifier ?? "USD").precision(.significantDigits(4)))
            Text(remainingTime, format: .number)
            Text(remainingPerDay, format: .currency(code: Locale.current.currency?.identifier ?? "USD").precision(.significantDigits(4)))

            ForEach(reportsViewModel.wrappedBalances) { balance in
                HStack {
                    Text(balance.accountName)
                    Text(balance.balance.description)
                }
            }

            Button("Refresh accounts") {
                Task {
                    do {
                        if reportsViewModel.financePermissionStatus != .authorized {
                            try await reportsViewModel.requestAccess()
                        }
                        try await reportsViewModel.refreshAccountBalances()
                    } catch {
                        print("could not get finance permission")
                    }
                }
            }
        }
    }
}

#Preview {
    let container: ModelContainer = {
        let container: ModelContainer = try! ModelContainer(for: Schema(versionedSchema: SimpleBudgetSchemaV100.self),
                                                            migrationPlan: SimpleBudgetSchemaV100MigrationPlan.self,
                                                            configurations: ModelConfiguration(isStoredInMemoryOnly: true))

        let sampleAccounts = [
            ("Checking", Decimal(100), false),
            ("Credit Card", Decimal(50), true),
        ]

        for (name, balance, isDebt) in sampleAccounts {
            let account = Account()
            account.name = name
            account.balance = balance
            account.isDebt = isDebt
            container.mainContext.insert(account)
        }

        let sampleEnvelopes = [
            ("Groceries", Decimal(20)),
        ]

        for (name, amount) in sampleEnvelopes {
            let envelope = Envelope()
            envelope.name = name
            envelope.amount = amount
            container.mainContext.insert(envelope)
        }

        let sampleGoals = [
            ("Vacation", Decimal(12), Recurrence.monthly, Calendar.current.date(byAdding: .day, value: 15, to: Date())!),
        ]

        for (name, amount, recurrence, targetDate) in sampleGoals {
            let goal = Goal()
            goal.name = name
            goal.amount = amount
            goal.recurrence = recurrence
            goal.targetDate = targetDate
            container.mainContext.insert(goal)
        }

        return container
    }()

    let viewModel: ReportsViewModel = {
        let vm = ReportsViewModel(store: MockFinanceStore())
        vm.wrappedBalances = [
            WrappedAccountBalance(accountName: "Checking", balance: 1500.00),
            WrappedAccountBalance(accountName: "Savings", balance: 5000.00),
        ]
        return vm
    }()

    Reports(viewModel: viewModel)
        .modelContainer(container)
}
