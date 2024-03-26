//
//  AlertError.swift
//  ScratchingCard
//
//  Created by Raul Batista on 26.03.2024.
//

import Foundation
import SwiftUI

protocol AlertError: LocalizedError {
    var localizedTitle: String { get }
    var localizedMessage: String { get }
}
