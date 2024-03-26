//
//  ButtonStyle.swift
//  ScratchingCard
//
//  Created by Raul Batista on 25.03.2024.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.bold())
            .foregroundStyle(Color.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(configuration.isPressed
                          ? Color.primaryButtonBackground.opacity(0.8)
                          : Color.primaryButtonBackground)
            )
    }
}
