//
//  ErrorResponse.swift
//  WorldOfPayBack
//
//  Created by Maria on 11/12/2023.
//

import Foundation

enum ErrorResponse: Decodable {
    case payment(PaymentErrorResponse)
    case exception(ExceptionResponse)

    enum PaymentErrorDataKeys: CodingKey {
        case key
        case errorResponse
    }

    enum ExceptionDataKeys: CodingKey {
        case title
        case error
        case message
    }

    init(from decoder: Decoder) throws {
        if let paymentContainer = try? decoder.container(keyedBy: PaymentErrorDataKeys.self),
           let key = try paymentContainer.decodeIfPresent(String.self, forKey: .key),
           (key == "VALIDATION_STRIPE" || key == "EXCEPTION_STRIPE") {

            let errorResponse = try paymentContainer.decode([PaymentErrorResponse].self, forKey: .errorResponse)
            let code = errorResponse.first?.code
            let title = errorResponse.first?.title
            let message = errorResponse.first?.message ?? "N/A"

            self = .payment(PaymentErrorResponse(code: code, title: title, message: message))
            return
        }

        if let exceptionContainer = try? decoder.container(keyedBy: ExceptionDataKeys.self) {
            let title = try exceptionContainer.decodeIfPresent(String.self, forKey: .title)
            let error = try exceptionContainer.decodeIfPresent(String.self, forKey: .error)
            let message = try exceptionContainer.decodeIfPresent(String.self, forKey: .message) ?? "N/A"

            self = .exception(ExceptionResponse(title: title, error: error, message: message))
            return
        }

        throw DecodingError.dataCorrupted(DecodingError.Context(
            codingPath: decoder.codingPath,
            debugDescription: "Unable to decode ErrorResponse"
        ))
    }
}

struct PaymentErrorResponse: Decodable {
    let code: String?
    let title: String?
    let message: String
}


struct ExceptionResponse: Decodable {
    let title: String?
    let error: String?
    let message: String
}
