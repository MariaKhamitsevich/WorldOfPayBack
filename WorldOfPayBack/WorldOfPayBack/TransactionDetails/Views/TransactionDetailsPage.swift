//
//  TransactionDetailsPage.swift
//  WorldOfPayBack
//
//  Created by Maria on 10/12/2023.
//

import SwiftUI

struct TransactionDetailsPage<ViewModel: TransactionDetailsPageManager>: View {
    @Environment (\.dismiss) var dissmissAction
    private let viewModel: ViewModel
    private var repeatHandler: (() -> Void)?

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            navigationBar
            detailsList
            Spacer()
            repeatButton
        }
        .padding(.bottom, 12)
        .navigationBarBackButtonHidden()
    }
}

// MARK: - Views
private extension TransactionDetailsPage {
    var navigationBar: some View {
        NavigationBar(
            title: Constants.transactionDetails,
            shouldShowButton: true
        ) {
            dissmissAction()
        }
    }

    var detailsList: some View {
        VStack {
            TransactionInfoView(leadingText: Constants.transactionTime, trailingText: viewModel.transactionCardModel.bookingDate, isShowDivider: true, trailingImageViewText: Constants.clock)
            TransactionInfoView(leadingText: Constants.partnerName, trailingText: viewModel.transactionCardModel.partnerName, isShowDivider: true)
            TransactionInfoView(leadingText: Constants.category, trailingText: "\(viewModel.transactionCardModel.category)", isShowDivider: true)
            TransactionInfoView(leadingText: Constants.amount, trailingText: viewModel.transactionCardModel.value.transactionValueText, isShowDivider: true, trailingImageViewText: Constants.currency)
            TransactionInfoView(leadingText: Constants.balanceAfterOperation, trailingText: Constants.balanceAfterOperation, isShowDivider: true)
            TransactionInfoView(leadingText: Constants.transactionDescription, trailingText: viewModel.transactionCardModel.transactioDescription, isShowDivider: true)
        }
    }

    @ViewBuilder
    var repeatButton: some View {
        if viewModel.couldRepeatOperation {
            Button(
                action: {
                    repeatHandler?()
                },
                label: {
                Text(Constants.repeatOperation)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background {
                        Color.blue
                    }
                    .clipShape(RoundedRectangle(cornerSize: .init(width: 8, height: 8)))
                    .padding(.horizontal, 12)
            })
        }
    }
}

extension TransactionDetailsPage {
    func repeatButtonHandler(_ action: @escaping () -> Void) -> Self {
        var view = self
        view.repeatHandler = repeatHandler
        return view
    }
}

// MARK: - Constants
private extension TransactionDetailsPage {
    enum Constants {
        static var transactionDetails: String {
            "Transaction Details"
        }
        static var transactionTime: String {
            "Time of transaction"
        }
        static var partnerName: String {
            "Partner Name"
        }
        static var category: String {
            "Category"
        }
        static var amount: String {
            "Amount"
        }
        static var balanceAfterOperation: String {
            "Balance after operation"
        }
        static var transactionDescription: String {
            "Transaction Description"
        }
        static var repeatOperation: String {
            "Repeat Operation"
        }
        static var clock: String {
            "clock"
        }
        static var currency: String {
            "currency"
        }
    }
}

#Preview {
    TransactionDetailsPage(
        viewModel: TransactionDetailsPageViewModel(
        transactionCardModel: .init(
                bookingDate: "Feb 4, 2022, 10:59 AM",
                partnerName: "Partner name",
                transactioDescription: "Transaction description",
                category: 2,
                value: .init(
                    amount: 10,
                    currency: .pbp
                )
            )
        )
    )
}
