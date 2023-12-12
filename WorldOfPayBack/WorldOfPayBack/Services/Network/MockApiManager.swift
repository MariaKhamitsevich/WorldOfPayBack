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
        // Simulate a delay of 1-2 seconds
        try await Task.sleep(nanoseconds: 1_000_000_000 * UInt64.random(in: 1...2))

        try randomThrowingError()

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

    private func randomThrowingError() throws {
        let randomNumber = Int.random(in: 1...10)

        switch randomNumber {
        case 1:
                throw NetworkError.urlRequestError(description: NetworkErrorParameters(description: "URL Request Error", code: nil))
        case 2:
                throw NetworkError.responseError(description: NetworkErrorParameters(description: "Response Error", code: nil))
        case 3:
            throw NetworkError.dataParsingError
        default:
            return
        }
    }
}
