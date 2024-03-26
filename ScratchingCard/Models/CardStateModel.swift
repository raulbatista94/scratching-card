//
//  CardStateModel.swift
//  ScratchingCard
//
//  Created by Raul Batista on 25.03.2024.
//

import Foundation

struct CardStateModel: Codable {
    let id: String
    var scratchedPoints: [CGPoint]
    var isReadyToBeActivated: Bool
    var isActivated: Bool
}
