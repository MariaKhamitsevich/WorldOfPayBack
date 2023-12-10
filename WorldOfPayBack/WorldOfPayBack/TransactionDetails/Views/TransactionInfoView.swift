//
//  TransactionInfoView.swift
//  WorldOfPayBack
//
//  Created by Maria on 10/12/2023.
//

import SwiftUI

struct TransactionInfoView: View {
    private let leadingText: String
    private let trailingText: String
    private let isShowDivider: Bool
    private let imageViewText: String?
    private let trailingImageViewText: String?

    init(
        leadingText: String,
        trailingText: String,
        isShowDivider: Bool = false,
        imageViewText: String? = nil,
        trailingImageViewText: String? = nil
    ) {
        self.leadingText = leadingText
        self.trailingText = trailingText
        self.isShowDivider = isShowDivider
        self.imageViewText = imageViewText
        self.trailingImageViewText = trailingImageViewText
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(alignment: .top, spacing: 12) {
                    leadingView

                    if imageViewText != nil {
                        imageView
                    }

                    Spacer()

                    trailingView

                    if trailingImageViewText != nil {
                        trailingImageView
                    }
                }
                .padding(.bottom, 18)

                if isShowDivider {
                    Color.gray
                        .frame(height: 1)
                }
            }
            .padding([.leading, .trailing], 10)
        }
        .padding(.vertical, 10)
    }
}

// MARK: - Views
private extension TransactionInfoView {
    var leadingView: some View {
        Text(leadingText)
            .foregroundColor(.gray)
            .font(.system(size: 16))
    }

    var trailingView: some View {
        Text(trailingText)
            .foregroundColor(.gray)
            .font(.system(size: 16))
            .lineSpacing(8)
            .multilineTextAlignment(.trailing)
    }

    @ViewBuilder
    var imageView: some View {
        if let imageViewText {
            PBAssetImage.image(named: imageViewText)
                .resizable()
                .scaledToFit()
                .frame(width: 24)
                .padding(.trailing, 20)
        }
    }

    @ViewBuilder
    var trailingImageView: some View {
        if let trailingImageViewText {
            PBAssetImage.image(named: trailingImageViewText)
                .resizable()
                .scaledToFit()
                .frame(width: 24)
                .padding(.leading, 10)
        }
    }
}

#Preview {
    TransactionInfoView(leadingText: "Date", trailingText: "Feb 4, 2022, 10:59 AM", imageViewText: "clock", trailingImageViewText: "clock")
}
