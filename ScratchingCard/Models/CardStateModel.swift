//
//  CardStateModel.swift
//  ScratchingCard
//
//  Created by Raul Batista on 25.03.2024.
//

import Foundation

struct CardStateModel: Codable {
    let scratchedPoints: [CGPoint]
    let isReadyToBeActivated: Bool
}
