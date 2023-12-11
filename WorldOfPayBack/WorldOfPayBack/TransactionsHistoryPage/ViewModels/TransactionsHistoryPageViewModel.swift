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
    func fetchTransactions() async
    func filterTransactions(filterRule: FilterType)
}

final class TransactionsHistoryPageViewModel: TransactionsHistoryPageManager {
    private let apiManager: any ApiManagering<PBTransactionsApiRequest>
    @Published private(set) var transactions: [TransactionCardModel] = []
    @Published private(set) var filteredTransactions: [TransactionCardModel] = []
    @Published private(set) var availableCategories: [Int] = []
    @Published private(set) var loadingStatus: LoadingStatus = .success
    @Published private(set) var loadingError: NetworkError?

    private var currentDate: Date {
        Date()
    }

    init(
        apiManager: any ApiManagering<PBTransactionsApiRequest> = MockApiManager() // TODO: replace mock by ApiManager(networkManger: NetworkManager(),  urlConfigurator: PBURLConfigurator())
    ) {
        self.apiManager = apiManager
    }

    func fetchTransactions() async {
        loadingStatus = .loading
        do {
            let transactionItems: TransactionModel = try await apiManager.makeRequest(endpoint: .transactions)
            Task { @MainActor in
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
            }
        } catch (let error) {
            loadingStatus = .failure
            loadingError = error as? NetworkError ?? .unknownError
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
