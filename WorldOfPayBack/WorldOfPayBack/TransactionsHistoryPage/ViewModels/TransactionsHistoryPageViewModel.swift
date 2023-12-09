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


}
