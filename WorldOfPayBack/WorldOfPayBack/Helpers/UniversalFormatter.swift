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
    }

    func getShortDateFormat(from dateString: String, format: DateFormat = .fullDate) -> String {
        guard let date = dateFromString(dateString, format: format) else { return dateString }
        return DateFormatter.localizedString(
            from: date,
            dateStyle: .medium,
            timeStyle: .short
        )
    }

    func stringFromDate(_ date: Date, format: DateFormat) -> String {
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: date)
    }

    func dateFromString(_ dateString: String, format: DateFormat) -> Date? {
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: dateString)
    }
}
