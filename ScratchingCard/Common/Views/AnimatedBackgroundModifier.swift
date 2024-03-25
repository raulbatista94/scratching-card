//
//  AnimatedBackgroundModifier.swift
//  ScratchingCard
//
//  Created by Raul Batista on 25.03.2024.
//

import SwiftUI

struct AnimatedBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.background(
            ZStack {
                LinearGradient(
                    colors: [
                        Color.backgroundPrimary,
                        Color.backgroundTertiary,
                        Color.backgroundSecondary
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                BubbleAnimationView()
            }
            .ignoresSafeArea(.all)
        )
    }
}

