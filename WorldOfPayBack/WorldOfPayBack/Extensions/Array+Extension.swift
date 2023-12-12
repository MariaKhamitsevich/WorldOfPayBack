//
//  Array+Extension.swift
//  WorldOfPayBack
//
//  Created by Maria on 09/12/2023.
//

import Foundation

extension Array where Element == URLQueryItem {
    func percentEncoded() -> Array<Element> {
        return map { $0.percentEncoded() }
    }
}
