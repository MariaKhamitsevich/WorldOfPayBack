//
//  MockApiManager.swift
//  WorldOfPayBack
//
//  Created by Maria on 10/12/2023.
//

import Foundation

final class MockApiManager<API: ApiRequest>: ApiManagering {

    typealias API = API

    func makeRequest<T>(endpoint: API) async throws -> T where T : Decodable {
        if let path = Bundle.payBack.path(forResource: "PBTransactions", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    return try await decodeData(data: data)
                } catch {
                    throw error
                }
            }
        throw NetworkError.noDataError //TODO: error handling
    }

    private func decodeData<T: Decodable>(data: Foundation.Data) async throws -> T {
        try JSONDecoder().decode(T.self, from: data)
    }
}
