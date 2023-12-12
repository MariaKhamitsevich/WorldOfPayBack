//
//  TransactionsHistoryPageViewModel.swift
//  WorldOfPayBack
//
//  Created by Maria on 09/12/2023.
//

import Foundation

protocol TransactionsHistoryPageManager: ObservableObject {
    var transactions: [TransactionCardModel] { get }
    var filteredTransactions: [TransactionCardModel] { get }
    var availableCategories: [Int] { get }
    var loadingStatus: LoadingStatus { get }
    var loadingError: NetworkError? { get }
    var isLoading: Bool { get }
    var totalAmountText: String { get }
    func fetchTransactions() async
    func filterTransactions(filterRule: FilterType)
}

final class TransactionsHistoryPageViewModel: TransactionsHistoryPageManager {
    private let apiManager: any ApiManagering<PBTransactionsApiRequest>
    @Published private(set) var transactions: [TransactionCardModel] = []
    @Published private(set) var filteredTransactions: [TransactionCardModel] = []
    @Published private(set) var availableCategories: [Int] = []
    @Published private(set) var loadingStatus: LoadingStatus = .loading
    @Published private(set) var isLoading: Bool = true
    @Published private(set) var loadingError: NetworkError?

    private var currentDate: Date {
        Date()
    }

    private var currencyTotals: [Currency : Int] {
        getCurrencyTotals(from: filteredTransactions.compactMap { $0.value })
    }

    var totalAmountText: String {
        getCurrencyDescription(from: currencyTotals)
    }

    init(
        apiManager: any ApiManagering<PBTransactionsApiRequest> = MockApiManager() // TODO: replace mock by ApiManager(networkManger: NetworkManager(),  urlConfigurator: PBURLConfigurator())
    ) {
        self.apiManager = apiManager
        setupPublished()
    }

    @MainActor
    func fetchTransactions() async {
        loadingStatus = .loading
        transactions.removeAll()
        filteredTransactions.removeAll()
        do {
            let transactionItems: TransactionModel = try await apiManager.makeRequest(endpoint: .transactions)
            Task {
                transactions = transactionItems.items.compactMap {
                    TransactionCardModel(
                        bookingDate: convertFromDateString($0.transactionDetail.bookingDate),
                        partnerName: $0.partnerDisplayName,
                        transactioDescription: $0.transactionDetail.description ?? "",
                        category: $0.category,
                        value: $0.transactionDetail.value
                    )
                }
                getAvailableCategories(from: transactionItems)
                filterTransactions(filterRule: .dateNewest)
                loadingStatus = .success
                loadingError = nil
            }
        } catch (let error) {
            Task {
                loadingStatus = .failure
                loadingError = error as? NetworkError ?? .unknownError
            }
        }
    }

    func filterTransactions(filterRule: FilterType) {
        switch filterRule {
            case .category(let number):
                filteredTransactions = filterByCategory(items: transactions, number)
            case .dateNewest:
                filteredTransactions = sortTransitionsByDate(items: transactions, increasing: true)
            case .dateOldest:
                filteredTransactions = sortTransitionsByDate(items: transactions, increasing: false)
        }
    }
}

private extension TransactionsHistoryPageViewModel {
    func setupPublished() {
        $loadingStatus
            .map { $0 == .loading }
            .assign(to: &$isLoading)
    }
}

private extension TransactionsHistoryPageViewModel {
    func getAvailableCategories(from model: TransactionModel) {
        availableCategories = Array(Set(model.items.map { $0.category }).sorted())

    }

    func filterByCategory(items: [TransactionCardModel], _ category: Int) -> [TransactionCardModel] {
        items.filter { $0.category == category }
    }

    func sortTransitionsByDate(items: [TransactionCardModel], increasing: Bool) -> [TransactionCardModel] {
        items.sorted(by: {
            let firstDate = convertToDate($0.bookingDate) ?? currentDate
            let secondDate = convertToDate($1.bookingDate) ?? currentDate

            return increasing ? (firstDate > secondDate) : (firstDate < secondDate)
        })
    }

    func convertFromDateString(_ dateString: String?) -> String {
        guard let dateString else { return "N/A" }
        return UniversalFormatter.shared.getShortDateFormat(from: dateString)
    }

    func convertToDate(_ dateString: String?) -> Date? {
        UniversalFormatter.shared.dateFromString(dateString ?? "", format: .shortDate)
    }
}

private extension TransactionsHistoryPageViewModel {
    func getCurrencyTotals(from transactions: [TransactionValue]) -> [Currency: Int] {
        // Dictionary to store total amounts for each currency
        var currencyTotals: [Currency: Int] = [:]

        // Calculate totals for each currency
        for transaction in transactions {
            let currency = transaction.currency
            let amount = transaction.amount

            if var total = currencyTotals[currency] {
                total += amount
                currencyTotals[currency] = total
            } else {
                currencyTotals[currency] = amount
            }
        }
        return currencyTotals
    }

    func getCurrencyDescription(from currencyTotals: [Currency : Int]) -> String {
        let summaryText = currencyTotals.reduce("") { $0 + " \($1.value) \($1.key.rawValue.uppercased()),"}
        return String(summaryText.dropLast())
    }
}
