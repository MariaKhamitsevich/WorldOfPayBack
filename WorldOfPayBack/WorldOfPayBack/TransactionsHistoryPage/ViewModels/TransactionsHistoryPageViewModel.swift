//
//  TransactionsHistoryPageViewModel.swift
//  WorldOfPayBack
//
//  Created by Maria on 09/12/2023.
//

import Foundation

protocol TransactionsHistoryPageManager: ObservableObject {
    var transactions: [TransactionCardModel] { get }
}

final class TransactionsHistoryPageViewModel: TransactionsHistoryPageManager {
    private let apiManager: any ApiManagering<PBTransactionsApiRequest>

    @Published private(set) var transactions: [TransactionCardModel] = []

    init(
        apiManager: any ApiManagering<PBTransactionsApiRequest> = ApiManager(
            networkManger: NetworkManager(),
            urlConfigurator: PBURLConfigurator()
        )
    ) {
        self.apiManager = apiManager
    }

    func fetchTransactions() async {
        do {
            let transactionItems: TransactionModel = try await apiManager.makeRequest(endpoint: .transactions)
            Task { @MainActor in
                transactions = transactionItems.items.compactMap {
                    TransactionCardModel(
                        bookingDate: convertDate($0.transactionDetail.bookingDate),
                        partnerName: $0.partnerDisplayName,
                        transactioDescription: $0.transactionDetail.description ?? "",
                        value: $0.transactionDetail.value
                    )
                }

            }
        } catch {
            debugPrint(error.localizedDescription) //TODO: error handling
        }
    }
}

private extension TransactionsHistoryPageViewModel {
    func convertDate(_ dateString: String?) -> String {
        guard let dateString else { return "N/A" }
        return UniversalFormatter.shared.getShortDateFormat(from: dateString)
    }
}
