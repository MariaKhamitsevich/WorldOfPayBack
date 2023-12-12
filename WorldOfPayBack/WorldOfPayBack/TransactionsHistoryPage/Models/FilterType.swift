//
//  FilterType.swift
//  WorldOfPayBack
//
//  Created by Maria on 10/12/2023.
//

import Foundation

protocol FilterIterable: Equatable {
    var filterName: String { get }
}

enum FilterType: CaseIterable, FilterIterable {
    var id: UUID {
        UUID()
    }

    case category(number: Int)
    case dateNewest
    case dateOldest

    static var allCases: [FilterType] {
        return [.category(number: 1), .dateNewest, .dateOldest]
    }

    var filterName: String {
        switch self {
            case .category:
                "Category"
            case .dateNewest:
                "Date Newest"
            case .dateOldest:
                "Date Oldest"
        }
    }
}
