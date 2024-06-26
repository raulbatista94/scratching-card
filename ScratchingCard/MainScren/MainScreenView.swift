//
//  MainScreenView.swift
//  ScratchingCard
//
//  Created by Raul Batista on 23.03.2024.
//

import SwiftUI
import Combine

struct MainScreenView: View {
    @ObservedObject private var viewModel: MainScreenViewModel

    init(viewModel: MainScreenViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Spacer()

            Text("mainScreen.title")
                .font(.title.weight(.regular))
                .shadow(radius: 2, y: 4)
                .foregroundStyle(.white)

            Spacer()

            cardView

            Spacer()

            actionButtonsStack
            .padding(.horizontal)

            Spacer()
        }
        .modifier(AnimatedBackgroundModifier())

    }
}

// MARK: - Subviews
private extension MainScreenView {
    var cardView: some View {
        CardView(
            couponCode: viewModel.id,
            shouldRevealCode: $viewModel.isCardReadyToBeActivated,
            scratchedPoints: $viewModel.scratchedPoints
        )
        .shadow(
            color: viewModel.isActivated
            ? Color.green.opacity(0.4)
            : Color(.sRGBLinear, white: 0, opacity: 0.33),
            radius: 15
        )
        .padding(.horizontal)
        .onAppear {
            viewModel.send(action: .viewDidAppear)
        }
    }

    var actionButtonsStack: some View {
        HStack(spacing: 16) {
            Button("mainScreen.scratchButtonTitle") {
                viewModel.send(action: .openScratchScreen)
            }
            .buttonStyle(PrimaryButtonStyle())

            Button(
                viewModel.isActivated
                ? "mainScreenView.resetButtonTitle"
                : "mainScreen.activateButtonTitle"
            ) {
                viewModel.send(action: .openActivationScreen)
            }
            .buttonStyle(PrimaryButtonStyle())
            .opacity(viewModel.isCardReadyToBeActivated ? 1 : 0.7)
            .disabled(!viewModel.isCardReadyToBeActivated)
        }
    }
}

#if DEBUG
#Preview {
    MainScreenView(viewModel: MainScreenViewModel.mockModel)
}
#endif
