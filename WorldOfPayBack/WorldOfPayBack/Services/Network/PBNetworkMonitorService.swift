//
//  PBNetworkMonitorService.swift
//  WorldOfPayBack
//
//  Created by Maria on 09/12/2023.
//

import Foundation
import Network

protocol NetworkMonitorService: ObservableObject {
    var isConnected: Bool { get }
}

final class PBNetworkMonitorService: NetworkMonitorService {
    static var shared = PBNetworkMonitorService()

    private let networkMonitor = NWPathMonitor()
    private let queue = DispatchQueue(label: Constants.networkConnectivityQueue)
    @Published private(set) var isConnected = false

    private init() {
        startMonitor()
    }

    private func startMonitor() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        networkMonitor.start(queue: queue)

    }
}

//MARK: - Constants
private extension PBNetworkMonitorService {
    enum Constants {
        static let networkConnectivityQueue = "Network Conectivity Monitor"
    }
}
