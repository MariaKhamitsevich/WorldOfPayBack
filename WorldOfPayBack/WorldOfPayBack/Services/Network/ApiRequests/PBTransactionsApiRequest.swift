//
//  PBTransactionsApiRequest.swift
//  WorldOfPayBack
//
//  Created by Maria on 09/12/2023.
//

import Foundation

enum PBTransactionsApiRequest {
    case transactions
}

extension PBTransactionsApiRequest: ApiRequest {
    var apiPath: String {
        switch self {
            default:
               return path
        }
    }

    var path: String {
        switch self {
            case .transactions:
              return  "/transactions"
        }
    }

    var method: String {
        switch self {
            case .transactions:
              return  "GET"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
            case .transactions:
               return []
        }
    }

    var customHeaders: [String: String] {
        switch self {
            case .transactions:
               return [:]
        }
    }
}
