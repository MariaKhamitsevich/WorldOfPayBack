//
//  UniversalFormatter.swift
//  WorldOfPayBack
//
//  Created by Maria on 10/12/2023.
//

import Foundation

final class UniversalFormatter {
    static let shared: UniversalFormatter = UniversalFormatter()

    let dateFormatter: DateFormatter //TODO: add numberFormatter and currencyFormatter

    private init() {
        dateFormatter = DateFormatter()
    }
}

// MARK: Date formating
extension UniversalFormatter {
    enum DateFormat: String {
        case fullDate = "yyyy-MM-dd'T'HH:mm:ssZ"
        case shortDate = "MMM d, yyyy, h:mm a"
    }

    func getShortDateFormat(from dateString: String, initialFormat: DateFormat = .fullDate) -> String {
        guard let date = dateFromString(dateString, format: initialFormat) else { return dateString }
        dateFormatter.dateFormat = DateFormat.shortDate.rawValue
        return dateFormatter.string(from: date)
    }

    func stringFromDate(_ date: Date, format: DateFormat = .fullDate) -> String {
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: date)
    }

    func dateFromString(_ dateString: String, format: DateFormat = .fullDate) -> Date? {
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: dateString)
    }
}
