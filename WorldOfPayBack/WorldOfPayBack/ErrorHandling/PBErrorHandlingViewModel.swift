//
//  PBErrorHandlingViewModel.swift
//  WorldOfPayBack
//
//  Created by Maria on 11/12/2023.
//

import Foundation
import Combine

public class PBErrorHandlingViewModel: ObservableObject {

    @Published private var error: NetworkError?
    @Published private(set) var showTapToRefresh = false
    @Published private(set) var errorMessage: String = ""

    init(error: NetworkError?) {
        self.error = error
    }

    func setErrorView() {
        if PBNetworkMonitorService.shared.isConnected {
            guard let error,
                  self.errorMessage.isEmpty else { return }
            switch error {
                case .urlRequestError:
                    self.errorMessage = Constants.errorOccured
                case .responseError(let description):
                    self.errorMessage = description.description
                case .dataParsingError, .noDataError, .unknownError: //TODO: add separate cases
                    self.errorMessage = Constants.maintenanceError
            }
            self.showTapToRefresh = true
        } else {
            self.errorMessage = Constants.notConnected
            self.showTapToRefresh = false
        }
    }

    private enum Constants {
        static var notConnected = "Looks like the internet connection is slow or unstable."
        static var errorOccured = "An error has occured."
        static var maintenanceError = "We are currently undergoing maintenance and some features may not be available"
    }
}
