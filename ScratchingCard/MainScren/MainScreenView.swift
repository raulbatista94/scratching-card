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

            Text("O2 Slovakia")
                .font(.title.weight(.regular))
                .shadow(radius: 2, y: 4)
                .foregroundStyle(.white)

            Spacer()

            CardView(
                couponCode: viewModel.couponCode,
                scratchedPoints: $viewModel.scratchedPoints
            )
            .shadow(radius: 15)
            .padding(.horizontal)
            .onAppear {
                viewModel.send(action: .viewDidAppear)
            }

            Spacer()

            HStack(spacing: 16) {
                Button("Scratch") {
                    viewModel.send(action: .openScratchScreen)
                }
                .buttonStyle(PrimaryButtonStyle())

                Button("Activate") {
                    viewModel.send(action: .openActivationScreen)
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(.horizontal)

            Spacer()
        }
        .modifier(AnimatedBackgroundModifier())

    }
}

struct DrawingMask: Shape {
    var path: Path

    func path(in rect: CGRect) -> Path {
        return path
    }
}

#if DEBUG
#Preview {
    MainScreenView(viewModel: MainScreenViewModel.mockModel)
}
#endif
