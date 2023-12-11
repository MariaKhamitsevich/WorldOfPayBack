//
//  TransactionDetailsPageViewModel.swift
//  WorldOfPayBack
//
//  Created by Maria on 10/12/2023.
//

import Foundation

protocol TransactionDetailsPageManager: ObservableObject {
    var transactionCardModel: TransactionCardModel { get }
    var couldRepeatOperation: Bool { get }
}

final class TransactionDetailsPageViewModel: TransactionDetailsPageManager {
    private(set) var transactionCardModel: TransactionCardModel

    var couldRepeatOperation: Bool {
        transactionCardModel.category == 2 // Replace by any other condition
    }

    init(transactionCardModel: TransactionCardModel) {
        self.transactionCardModel = transactionCardModel
    }
}
