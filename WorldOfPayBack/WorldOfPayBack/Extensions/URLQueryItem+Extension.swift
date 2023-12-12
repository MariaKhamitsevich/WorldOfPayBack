//
//  URLQueryItem+Extension.swift
//  WorldOfPayBack
//
//  Created by Maria on 09/12/2023.
//

import Foundation

extension URLQueryItem {
    func percentEncoded() -> URLQueryItem {
        var newQueryItem = self
        newQueryItem.value = value?
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed.subtracting(CharacterSet(charactersIn: ",")))

        return newQueryItem
    }
}
