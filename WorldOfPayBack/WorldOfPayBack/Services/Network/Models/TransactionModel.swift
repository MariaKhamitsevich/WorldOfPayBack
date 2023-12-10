//
//  TransactionModel.swift
//  WorldOfPayBack
//
//  Created by Maria on 09/12/2023.
//

import Foundation

struct TransactionModel: Decodable {
    let items: [TransactionItem]

    init(items: [TransactionItem]) {
        self.items = items
    }

    enum CodingKeys: CodingKey {
        case items
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try container.decodeIfPresent([TransactionItem].self, forKey: .items) ?? []
    }
}

struct TransactionItem: Decodable {
    let partnerDisplayName: String
    let category: Int
    let transactionDetail: TransactionDetail
}

struct TransactionDetail: Decodable {
    let description: String?
    let bookingDate: String?
    let value: TransactionValue
}

struct TransactionValue: Decodable {
    let amount: Int
    let currency: Currency
}

enum Currency: String, Decodable, CaseIterable {
    case pbp = "PBP"
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = Currency(rawValue: rawValue) ?? .unknown
    }
}
