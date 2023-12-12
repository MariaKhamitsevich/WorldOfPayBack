//
//  NetworkManager.swift
//  WorldOfPayBack
//
//  Created by Maria on 09/12/2023.
//

import Foundation

struct NetworkErrorParameters {
    let title: String?
    let description: String
    let code: Int?

    init(
        title: String? = nil,
        description: String,
        code: Int?
    ) {
        self.title = title
        self.description = description
        self.code = code
    }
}

enum NetworkError: Error {
    case urlRequestError(description: NetworkErrorParameters)
    case responseError(description: NetworkErrorParameters)
    case dataParsingError
    case noDataError
    case unknownError
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
        do {
            let error = try JSONDecoder().decode(ErrorResponse.self, from: data as Foundation.Data)
            let errorParameters: NetworkErrorParameters
            switch error {
            case let .payment(paymentError):
                errorParameters = NetworkErrorParameters(title: paymentError.title,
                                                         description: paymentError.message,
                                                         code: statusCode)
            case let .exception(exceptionResponse):
                errorParameters = NetworkErrorParameters(title: exceptionResponse.title,
                                                         description: exceptionResponse.message,
                                                         code: statusCode)
            }
            throw NetworkError.responseError(description: errorParameters)
        }
        catch {
            let errorParameters = NetworkErrorParameters(description: responseDescription, code: statusCode)
            throw NetworkError.responseError(description: errorParameters)
        }
    }

    func decodeData<T: Decodable>(data: Foundation.Data) async throws -> T {
        try JSONDecoder().decode(T.self, from: data)
    }
}
