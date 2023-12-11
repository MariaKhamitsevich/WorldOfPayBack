//
//  Color+Extension.swift
//  WorldOfPayBack
//
//  Created by Maria on 11/12/2023.
//

import SwiftUI

extension Color {
    /// Creates a color from a color asset that you indicate by a color asset type.
    /// - Parameter name: The color asset matching the color resource to look up.
    init(pbAsset colorAsset: PBAssetColor) {
        self.init(colorAsset.rawValue, bundle: .payBack)
    }
}

enum PBAssetColor: String, PBAssetDisplayable {
    case errorMessageRed

    var color: SwiftUI.Color { .init(pbAsset: self) }
}

