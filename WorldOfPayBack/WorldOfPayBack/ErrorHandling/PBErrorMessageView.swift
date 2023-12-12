//
//  PBErrorMessageView.swift
//  WorldOfPayBack
//
//  Created by Maria on 11/12/2023.
//

import SwiftUI

struct PBErrorMessageView: View {
    @StateObject private var viewModel: PBErrorHandlingViewModel
    @State private var message: String = ""
    @State private var showTapToRefresh: Bool = false
    private var tapOnRefreshAction: (() -> Void)?

    init(viewModel: PBErrorHandlingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
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
        .onAppear {
            viewModel.setErrorView()
            message = viewModel.errorMessage
            showTapToRefresh = viewModel.showTapToRefresh
        }
        .onChange(of: viewModel.errorMessage) { newValue in
            message = newValue
            showTapToRefresh = viewModel.showTapToRefresh
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
    PBErrorMessageView(
        viewModel: .init(error: .responseError(description: .init(description: "Response Error", code: nil))))
}
