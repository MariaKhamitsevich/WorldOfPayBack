//
//  PBTabItemView.swift
//  WorldOfPayBack
//
//  Created by Maria on 09/12/2023.
//

import SwiftUI

struct PBTabItemView: View {
    private var tabItem: PBTabItem

    init(tabItem: PBTabItem) {
        self.tabItem = tabItem
    }

    var body: some View {
        VStack {
            Image(systemName: tabItem.image)
            Text(tabItem.title)
        }
    }
}

extension PBTabItemView {
    enum PBTabItem {
        case home
        case history
        case account

        var title: String {
            switch self {
                case .home:
                    return "Home"
                case .history:
                    return "History"
                case .account:
                    return "Profile"
            }
        }

        var image: String {
            switch self {
                case .home:
                    return "house.circle.fill"
                case .history:
                    return "creditcard.circle.fill" //TODO: update image
                case .account:
                    return "person.circle.fill"
            }
        }
    }
}
