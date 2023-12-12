//
//  InfoConfig.swift
//  WorldOfPayBack
//
//  Created by Maria on 09/12/2023.
//

import Foundation

public enum InfoConfig {
    static let defaultEnvironment = Constants.dev

    public static func buildEnv() -> String {
        valueObject(forKey: Constants.buildEnvironment) ?? defaultEnvironment
    }
}

private extension InfoConfig {
    static func valueObject(forKey key: String, bundle: Bundle = .main) -> String? {

        let value = value(key: key, bundle: bundle)
        return value == "" ? nil : value
    }

    static func value(key: String, bundle: Bundle = .main) -> String {
        guard let configDictionary = getConfigDictionary(bundle: bundle),
              let value = configDictionary[key] as? String
        else {
            return ""
        }

        return value
    }

    static func getConfigDictionary(bundle: Bundle) -> NSDictionary? {
        guard let path = bundle.path(forResource: Constants.info, ofType: Constants.infoType),
              let dictionary = NSDictionary(contentsOfFile: path)
        else {
            return nil
        }
        return dictionary
    }
}

//MARK: - Constants
private extension InfoConfig {
    enum Constants {
        static let buildEnvironment = "buildEnvironment"
        static let dev = "DEV"
        static let info = "Info"
        static let infoType = "plist"
    }
}
