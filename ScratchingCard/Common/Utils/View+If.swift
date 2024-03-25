//
//  View+If.swift
//  ScratchingCard
//
//  Created by Raul Batista on 25.03.2024.
//

import SwiftUI

// Allows conditional view modifications in SwiftUI
extension View {
    @ViewBuilder
    func `if`(_ condition: Bool, transform: (Self) -> some View) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

