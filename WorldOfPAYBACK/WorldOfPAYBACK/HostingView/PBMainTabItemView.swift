//
//  PBMainTabItemView.swift
//  WorldOfPAYBACK
//
//  Created by MAria on 08/12/2023.
//

import SwiftUI

struct PBMainTabItemView: View {
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

enum PBTabItem {
    case home
    case account

    var title: String {
        switch self {
        case .home:
           return "Home"
        case .account:
            return "Profile"
        }
    }

    var image: String {
        switch self {
        case .home:
            return "house.circle.fill"
        case .account:
            return "person.circle.fill"
        }
    }
}

