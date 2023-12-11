//
//  TransactionCardCell.swift
//  WorldOfPayBack
//
//  Created by Maria on 10/12/2023.
//

import SwiftUI

struct TransactionCardCell: View {
    private let viewModel: TransactionCardViewModel

    init(viewModel: TransactionCardViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text(viewModel.transactionCardModel.bookingDate)
                    .italic()
                    .font(.system(size: 14))

                Spacer()

                Text(viewModel.transactionCardModel.value.transactionValueText)
                    .bold()
                    .font(.system(size: 18))
            }

            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(viewModel.transactionCardModel.partnerName)
                            .bold()
                            .font(.system(size: 16))

                        Spacer()

                        Text("\(Constants.category) \(viewModel.transactionCardModel.category)")
                            .font(.system(size: 14))
                    }
                    Text(viewModel.transactionCardModel.transactioDescription)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .font(.system(size: 12))
                }
                Spacer()
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background {
            Color.blue.opacity(0.4)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(Color.blue.opacity(0.7), lineWidth: 2.0)
        )
        .cornerRadius(8.0)
    }
}

private extension TransactionCardCell {
    enum Constants {
        static let category = "Category"
    }
}
struct TransactionCardCell_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 14 Pro Max", "iPhone SE (3rd generation)"], id: \.self) { deviceName in
            TransactionCardCell(
                viewModel: TransactionCardViewModel(
                    transactionCardModel: .init(
                        bookingDate: "Feb 4, 2022, 10:59 AM",
                        partnerName: "Partner name",
                        transactioDescription: "Transaction description",
                        category: 1,
                        value: .init(
                            amount: 10,
                            currency: .pbp
                        )
                    )
                )
            )
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
        }
    }
}
