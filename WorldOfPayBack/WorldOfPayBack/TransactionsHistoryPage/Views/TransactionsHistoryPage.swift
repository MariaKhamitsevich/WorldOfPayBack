//
//  TransactionsHistoryPage.swift
//  WorldOfPayBack
//
//  Created by Мария on 09/12/2023.
//

import SwiftUI

struct TransactionsHistoryPage<ViewModel: TransactionsHistoryPageManager, NetworkMonitor: NetworkMonitorService>: View {
    @StateObject private var viewModel: ViewModel
    @StateObject private var networkMonitor: NetworkMonitor

    init(
        viewModel: ViewModel,
        networkMonitor: NetworkMonitor = PBNetworkMonitorService.shared
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _networkMonitor = StateObject(wrappedValue: networkMonitor)
    }

    var body: some View {
        Group {
            if networkMonitor.isConnected {
                NavigationView {
                    VStack {
                        navigationBar
                        filterView
                        transactionsList
                    }
                }
            } else {
                VStack {
                    navigationBar
                    errorView
                }
            }
        }
        .task {
            if networkMonitor.isConnected {
                await runTasks()
            }
        }
    }

    private func runTasks() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await viewModel.fetchTransactions()
            }
        }
    }
}

// MARK: - Views
private extension TransactionsHistoryPage {
    var navigationBar: some View {
        NavigationBar(title: Constants.transactionHistory, shouldShowButton: false)
    }

    var filterView: some View {
        FilterView(availableCategories: viewModel.availableCategories)
            .onFilterTap {
                viewModel.filterTransactions(filterRule: $0)
            }
            .onCategoryTap {
                viewModel.filterTransactions(filterRule: .category(number: $0))
            }
    }

    var transactionsList: some View {
        List(viewModel.filteredTransactions, id: \.bookingDate) { transaction in
            NavigationLink {
                TransactionDetailsPage(
                    viewModel: TransactionDetailsPageViewModel(
                        transactionCardModel: transaction
                    )
                )
                .repeatButtonHandler {
                    debugPrint("Operation repeating")
                }
            } label: {
                transactionCardCellView(model: transaction)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 2, leading: 8, bottom: 2, trailing: 8))
            }

        }
        
        .listStyle(.plain)
    }

    func transactionCardCellView(model: TransactionCardModel) -> some View {
        TransactionCardCell(viewModel: TransactionCardViewModel(transactionCardModel: model))
    }

    var errorView: some View {
        VStack {
            PBErrorMessageView(viewModel: PBErrorHandlingViewModel(error: viewModel.loadingError))
                .onTapToRefresh {
                    Task {
                        await runTasks()
                    }
                }
            Spacer()
        }
    }
}

private extension TransactionsHistoryPage {
    enum Constants {
        static var transactionHistory: String {
            "Transactions History"
        }
    }
}

struct TransactionsHistoryPage_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 14 Pro Max", "iPhone SE (3rd generation)"], id: \.self) { deviceName in
            TransactionsHistoryPage(viewModel: TransactionsHistoryPageViewModel())
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
        }
    }
}
