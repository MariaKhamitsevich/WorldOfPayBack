//
//  URLConfigurator.swift
//  WorldOfPayBack
//
//  Created by Maria on 09/12/2023.
//

import Foundation

protocol URLConfiguring<API> {
    associatedtype API: ApiRequest
    func makeRequest(for parameter: API) -> URLRequest?
}



final class PBURLConfigurator<API: ApiRequest>: URLConfiguring {
    private let environment: BuildEnvironment

    init(
        environment: BuildEnvironment = BuildEnvironment.getEnvironment()
    ) {
        self.environment = environment
    }
}

extension PBURLConfigurator {

    private var scheme: String {
        "https"
    }

    private var host: String {
        switch environment {
            case .qa:
                return "api-test.payback.com"
            case .prod:
                return "api.payback.com"
            default:
                return "api-test.payback.com" //TODO: add host for .dev, .uat
        }
    }

    func makeRequest(for parameter: API) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = parameter.apiPath
        urlComponents.queryItems = parameter.queryItems.percentEncoded()

        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)

        parameter.customHeaders.forEach { (key, value) in
            request.setValue(value, forHTTPHeaderField: key)
        }

        request.httpMethod = parameter.method

        return request
    }
}
