//
//  Bundle+Extension.swift
//  WorldOfPayBack
//
//  Created by Maria on 09/12/2023.
//

import Foundation

private final class AnchorClass {}

extension Bundle {
    static let payBack = Bundle(for: AnchorClass.self)
}
