//
//  ContentView.swift
//  WorldOfPAYBACK
//
//  Created by Maria on 08/12/2023.
//

import SwiftUI

struct PBMainHostingView: View {
    @State private var home = UUID()
    @State private var homeTappedTwice: Bool = false
    @State private var tabSelected: PBTabItem = .home

    private var tabHandler: Binding<PBTabItem> {
        Binding(
            get: {
                tabSelected
            },
            set: {
                if $0 == self.tabSelected {
                    homeTappedTwice = true
                }
                tabSelected = $0
            })
    }

    var body: some View {
        TabView(selection: tabHandler) {
            Text("1")
                .id(home)
                .tabItem {
                    PBMainTabItemView(tabItem: .home)
                }
                .tag(PBTabItem.home)
                .onChange(of: homeTappedTwice) { _ in
                    home = UUID()
                    homeTappedTwice = false
                }

            Text("2")
                .tabItem {
                    PBMainTabItemView(tabItem: .account)
                }
                .tag(PBTabItem.account)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PBMainHostingView()
    }
}
