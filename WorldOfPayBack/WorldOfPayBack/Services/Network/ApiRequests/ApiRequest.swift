//
//  ApiRequest.swift
//  WorldOfPayBack
//
//  Created by Maria on 09/12/2023.
//

import Foundation

protocol ApiRequest {
    var apiPath: String { get }
    var method: String { get }
    var queryItems: [URLQueryItem] { get }
    var customHeaders: [String: String] { get }
}
