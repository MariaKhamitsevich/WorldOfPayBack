//
//  Image+Extension.swift
//  WorldOfPayBack
//
//  Created by Maria on 10/12/2023.
//

import SwiftUI

extension Image {
    /// Creates a labeled image that you can use as content for controls.
    ///
    /// - Parameter pbAsset: The image asset matching the image resource to lookup, as well as the
    ///     localization key with which to label the image.
    init(pbAsset imageAsset: PBAssetImage) {
        self.init(imageAsset.rawValue, bundle: .payBack)
    }
}

enum PBAssetImage: String, PBAssetDisplayable {
    case clock

    public var image: SwiftUI.Image { .init(pbAsset: self) }

    public static func image(named imageName: String) -> SwiftUI.Image {
        .init(imageName, bundle: .payBack)
    }
}
