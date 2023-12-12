//
//  BuildEnvironment.swift
//  WorldOfPayBack
//
//  Created by Maria on 09/12/2023.
//

import Foundation

public enum BuildEnvironment: String {
    case dev
    case qa
    case uat
    case prod

    public static func getEnvironment() -> BuildEnvironment {
        let environment = InfoConfig.buildEnv()
        return BuildEnvironment(rawValue: environment.lowercased()) ?? .qa
    }
}
