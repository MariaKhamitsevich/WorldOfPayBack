//
//  PBAssetDisplayable.swift
//  WorldOfPayBack
//
//  Created by Maria on 10/12/2023.
//

import Foundation

/// Helper protocol to use with PBAsset enums in order to give a default implementation
/// in order to quickly and easily iterate and display all available assets
protocol PBAssetDisplayable: CaseIterable, Identifiable, CustomStringConvertible {
    var id: Self { get }
    var description: String { get }
}

extension PBAssetDisplayable {
    public var id: Self { return self }
    public var description: String { return String(describing: self) }
}

