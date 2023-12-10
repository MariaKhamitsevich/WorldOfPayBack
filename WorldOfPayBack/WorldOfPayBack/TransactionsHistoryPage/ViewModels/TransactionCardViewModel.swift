//
//  TransactionCardViewModel.swift
//  WorldOfPayBack
//
//  Created by Maria on 10/12/2023.
//

import Foundation

final class TransactionCardViewModel {
    let transactionCardModel: TransactionCardModel

    var transactionValueText: String {
        "\(transactionCardModel.value.amount) \(transactionCardModel.value.currency.rawValue.uppercased())"
    }

    init(transactionCardModel: TransactionCardModel) {
        self.transactionCardModel = transactionCardModel
    }
}
