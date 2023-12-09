//
//  NetworkManager.swift
//  WorldOfPayBack
//
//  Created by Maria on 09/12/2023.
//

import Foundation

enum ErrorResponse: Error, Decodable {
    case urlResponse

    var title: String {
        ""
    }
}

enum NetworkError: Error {
    case urlRequestError
    case responseError
    case dataParsingError
    case noDataError
}

protocol NetworkManagering {
    func makeRequest<T: Decodable>(urlRequest: URLRequest) async throws -> T
}

final class NetworkManager: NetworkManagering {
    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func makeRequest<T>(urlRequest: URLRequest) async throws -> T where T : Decodable {
        let data = try await performRequest(urlRequest: urlRequest)
        return try await decodeData(data: data)
    }
}

private extension NetworkManager {
    func performRequest(urlRequest: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: urlRequest)
        let httpResponse = response as? HTTPURLResponse
        let statusCode = httpResponse?.statusCode

        guard let httpResponse, (200 ... 299) ~= httpResponse.statusCode else {
            return try await decodeError(data: data, statusCode: statusCode, responseDescription: response.description)
        }
        
        return data
    }

    func decodeError(data: Data, statusCode: Int?, responseDescription: String) async throws -> Data {
        // TODO: add decoder for error
        throw try JSONDecoder().decode(ErrorResponse.self, from: data as Foundation.Data)
    }

    func decodeData<T: Decodable>(data: Foundation.Data) async throws -> T {
        try JSONDecoder().decode(T.self, from: data)
    }
}
