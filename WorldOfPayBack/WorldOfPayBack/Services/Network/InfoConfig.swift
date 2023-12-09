//
//  InfoConfig.swift
//  WorldOfPayBack
//
//  Created by Maria on 09/12/2023.
//

import Foundation

public enum InfoConfig {
    static let defaultEnvironment = "DEV"

    public static func buildEnv() -> String {
        valueObject(forKey: "buildEnvironment") ?? defaultEnvironment
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
        guard let path = bundle.path(forResource: "Info", ofType: "plist"),
              let dictionary = NSDictionary(contentsOfFile: path)
        else {
            return nil
        }
        return dictionary
    }
}
