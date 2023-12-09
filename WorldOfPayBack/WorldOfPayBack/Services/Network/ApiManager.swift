//
//  ApiManager.swift
//  WorldOfPayBack
//
//  Created by Maria on 09/12/2023.
//

import Foundation

protocol ApiManagering<API> {
    associatedtype API: ApiRequest
    func makeRequest<T: Decodable>(endpoint: API) async throws -> T
}

final class ApiManager<API: ApiRequest>: ApiManagering {
    typealias API = API
    private let networkManger: NetworkManagering
    private let urlConfigurator: any URLConfiguring<API>

    init(
        networkManger: NetworkManagering,
        urlConfigurator: any URLConfiguring<API>
    ) {
        self.networkManger = networkManger
        self.urlConfigurator = urlConfigurator
    }

    func makeRequest<T: Decodable>(endpoint: API) async throws -> T {
        let request = urlConfigurator.makeRequest(for: endpoint)
        guard let request else { throw NetworkError.urlRequestError }
        return try await networkManger.makeRequest(urlRequest: request)
    }
}
