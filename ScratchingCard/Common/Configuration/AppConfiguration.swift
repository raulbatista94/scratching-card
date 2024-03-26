//
//  AppConfiguration.swift
//  ScratchingCard
//
//  Created by Raul Batista on 25.03.2024.
//

import Foundation

struct AppConfiguration: Decodable {
    private enum CodingKeys: String, CodingKey {
        case apiBaseUrl = "API_BASE_URL"
    }

    let apiBaseUrl: String
}

// MARK: Static properties
extension AppConfiguration {
    static let `default`: AppConfiguration = {
        guard let propertyList = Bundle.main.infoDictionary else {
            fatalError("Unable to get property list.")
        }

        guard let data = try? JSONSerialization.data(withJSONObject: propertyList, options: []) else {
            fatalError("Unable to instantiate data from property list.")
        }

        let decoder = JSONDecoder()

        guard let configuration = try? decoder.decode(AppConfiguration.self, from: data) else {
            fatalError("Unable to decode the Environment configuration file.")
        }

        return configuration
    }()
}
