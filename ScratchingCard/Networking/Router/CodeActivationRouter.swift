//
//  CodeActivationRouter.swift
//  ScratchingCard
//
//  Created by Raul Batista on 25.03.2024.
//

import Foundation

enum CodeActivationRouter {
    case activateCode(code: String)
}

extension CodeActivationRouter: Endpoint {
    var path: String {
        switch self {
        case .activateCode:
            "version"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var urlParameters: [String : Any]? {
        switch self {
        case let .activateCode(code):
            return ["code": code]
        }
    }

    var headers: [String : String]? {
        nil
    }
}
