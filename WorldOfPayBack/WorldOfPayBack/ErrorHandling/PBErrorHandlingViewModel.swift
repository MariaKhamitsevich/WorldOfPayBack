//
//  PBErrorHandlingViewModel.swift
//  WorldOfPayBack
//
//  Created by Maria on 11/12/2023.
//

import Foundation
import Combine

public class PBErrorHandlingViewModel: ObservableObject {

    @Published private var error: NetworkError
    @Published private(set) var showTapToRefresh = false
    @Published private(set) var errorMessage: String = ""

    init(error: NetworkError) {
        self.error = error
    }

    func setErrorView() {
        guard self.errorMessage.isEmpty else { return }
        if PBNetworkMonitorService.shared.isConnected {
            switch error {
                case .urlRequestError:
                    self.errorMessage = Constants.errorOccured
                    self.showTapToRefresh = true
                case .responseError(let description):
                    self.errorMessage = description.description
                    self.showTapToRefresh = false
                case .dataParsingError, .noDataError, .unknownError: //TODO: add separate cases
                    self.errorMessage = Constants.errorOccured
                    self.showTapToRefresh = false
            }
        } else {
            self.errorMessage = Constants.notConnected
            self.showTapToRefresh = true
        }
    }

    private enum Constants {
        static var notConnected = "Looks like the internet connection is slow or unstable."
        static var errorOccured = "An error has occured."
    }
}
