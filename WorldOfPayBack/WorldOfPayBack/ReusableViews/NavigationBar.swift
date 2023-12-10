//
//  NavigationBar.swift
//  WorldOfPayBack
//
//  Created by Maria on 09/12/2023.
//

import SwiftUI

struct NavigationBar: View {
    private let title: String
    private let shouldShowButton: Bool
    private let shouldShowTrailingView: Bool
    private let trailingView: AnyView
    private let handler: (() -> Void)?

    init(
        title: String,
        shouldShowButton: Bool = true,
        shouldShowTrailingView: Bool = false,
        trailingView: AnyView = AnyView(EmptyView()),
        handler: (() -> Void)? = nil
    ) {
        self.title = title
        self.shouldShowButton = shouldShowButton
        self.shouldShowTrailingView = shouldShowTrailingView
        self.trailingView = trailingView
        self.handler = handler
    }

    var body: some View {
        VStack {
            Text(title)
                .italic()
                .font(.system(size: 20))
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal, 20)
        .frame(height: 64)
        .overlay(alignment: .leading) {
            if shouldShowButton {
                Button {
                    handler?()
                } label: {
                    Image(systemName: "chevron.left.circle")
                        .frame(width: 44, height: 44, alignment: .center)
                        .foregroundColor(.black)
                }
                .offset(x: 14)
            }
        }
        .overlay(alignment: .trailing) {
            if shouldShowTrailingView {
                trailingView
                    .padding(.trailing, 20)
            }
        }
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(title: "Navigation")
    }
}
