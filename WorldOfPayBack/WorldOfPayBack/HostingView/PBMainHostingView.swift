//
//  ContentView.swift
//  WorldOfPayBack
//
//  Created by Maria on 09/12/2023.
//

import SwiftUI

struct PBMainHostingView: View {
    @State private var history = UUID()
    @State private var historyTappedTwice: Bool = false
    @State private var tabSelected: PBTabItemView.PBTabItem = .home

    private var tabHandler: Binding<PBTabItemView.PBTabItem> {
        Binding(
            get: {
                tabSelected
            },
            set: {
                if $0 == self.tabSelected {
                    historyTappedTwice = true
                }
                tabSelected = $0
            })
    }

    var body: some View {
        TabView(selection: tabHandler) {
            Text("Home Page")
                .tabItem {
                    PBTabItemView(tabItem: .home)
                }
                .tag(PBTabItemView.PBTabItem.home)


            Text("Transactions History")
                .id(history)
                .tabItem {
                    PBTabItemView(tabItem: .history)
                }
                .tag(PBTabItemView.PBTabItem.history)
                .onChange(of: historyTappedTwice) { _ in
                    history = UUID()
                    historyTappedTwice = false
                }

            Text("Account")
                .tabItem {
                    PBTabItemView(tabItem: .account)
                }
                .tag(PBTabItemView.PBTabItem.account)
        }
    }
}

struct PBMainHostingView_Previews: PreviewProvider {
    static var previews: some View {
        PBMainHostingView()
    }
}
