//
//  PBErrorMessageView.swift
//  WorldOfPayBack
//
//  Created by Maria on 11/12/2023.
//

import SwiftUI

struct PBErrorMessageView: View {
    private var message: String
    private var showTapToRefresh: Bool
    private var tapOnRefreshAction: (() -> Void)?

    init(
        message: String = "",
        showTapToRefresh: Bool = false
    ) {
        self.message = message
        self.showTapToRefresh = showTapToRefresh
    }

    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "exclamationmark.triangle")
                    .frame(width: 16, height: 16)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                VStack(alignment: .leading, spacing: 8) {
                    Text(message)
                        .font(.system(size: 13))
                        .lineSpacing(8)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.white)
                    HStack {
                        if showTapToRefresh {
                            Text(Constants.please)
                            Button {
                                tapOnRefreshAction?()
                            } label: {
                                Text(Constants.tapToRefresh)
                                    .underline(true, color: .white)
                            }
                            Spacer()
                        }
                    }
                    .font(.system(size: 13))
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
                }

                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .background {
            Color(pbAsset: .errorMessageRed)
        }
    }
}

extension PBErrorMessageView {
    func onTapToRefresh(_ action: @escaping (() -> Void)) -> Self {
        var view = self
        view.tapOnRefreshAction = action
        return view
    }
}

//MARK: Constants
private extension PBErrorMessageView {
    enum Constants {
        static let please = "Please"
        static let tapToRefresh = "Tap to refresh"
    }
}

#Preview {
    PBErrorMessageView(message: "Unknown error", showTapToRefresh: true)
}
