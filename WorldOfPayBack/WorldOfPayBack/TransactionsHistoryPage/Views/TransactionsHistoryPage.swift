//
//  TransactionsHistoryPage.swift
//  WorldOfPayBack
//
//  Created by Мария on 09/12/2023.
//

import SwiftUI

struct TransactionsHistoryPage<ViewModel: TransactionsHistoryPageManager>: View {
    @StateObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            NavigationBar(title: Constants.transactionHistory, shouldShowButton: false)
        }
    }
}

private extension TransactionsHistoryPage {
    enum Constants {
        static var transactionHistory: String { "Transactions History"
        }
    }
}

struct TransactionsHistoryPage_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 14 Pro Max", "iPhone SE (3rd generation)"], id: \.self) { deviceName in
            TransactionsHistoryPage(viewModel: TransactionsHistoryPageViewModel())
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
        }
    }
}
