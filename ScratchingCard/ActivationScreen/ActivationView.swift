//
//  ActivationView.swift
//  ScratchingCard
//
//  Created by Raul Batista on 25.03.2024.
//

import Combine
import SwiftUI

struct ActivationView: View {
    @ObservedObject var viewModel: ActivationViewModel

    var body: some View {
        VStack(alignment: .leading) {
            backButton

            Text(
                viewModel.isActivated
                ? "activationView.alreadyActivated"
                : "activationView.activateCode"
            )
                .font(.title.weight(.regular))
                .shadow(radius: 2, y: 4)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.top)

            Spacer()
            
            cardView

            Spacer()

            activationButton

        }
        .modifier(AnimatedBackgroundModifier())
        .alertError(
            error: viewModel.error,
            primaryButton: .default(
                Text("activationView.alert.dismissButton"),
                action: { viewModel.send(action: .dismissError) }
            )
        )
    }
}

extension ActivationView {
    var backButton: some View {
        Button {
            viewModel.send(action: .didTapDismiss)
        } label: {
            Image(systemName: "chevron.left")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 20)
                .foregroundStyle(Color.white)
                .padding()
                .padding(.trailing, 2)
                .background(
                    Circle()
                        .fill(Color.backgroundTertiary)
                )
        }
        .padding([.bottom, .leading])
    }

    var cardView: some View {
        CardView(
            couponCode: viewModel.cardState.id,
            shouldRevealCode: .constant(viewModel.cardState.isReadyToBeActivated || viewModel.cardState.isActivated),
            scratchedPoints: .constant(viewModel.cardState.scratchedPoints)
        )
        .if(viewModel.isLoading) { cardView in
            ZStack {
                cardView
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black.opacity(0.5))

                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(Color.white)
                            .scaleEffect(1.5, anchor: .center)

                    }
            }
        }
        .shadow(
            color: viewModel.error == nil
            ? (viewModel.isActivated ? Color.green.opacity(0.4) : Color(.sRGBLinear, white: 0, opacity: 0.33))
            : Color.red.opacity(0.4),
            radius: 15
        )
        .padding(.horizontal)
    }

    var activationButton: some View {
        Button("activationView.actionButtonTitle") {
            viewModel.send(action: .didTapActivate)
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(viewModel.isActivated)
        .opacity(viewModel.isActivated ? 0.5 : 1)
        .padding([.horizontal, .bottom])
    }
}

#if DEBUG
#Preview {
    ActivationView(
        viewModel: .init(
            cardState: .init(
                id: UUID().uuidString,
                scratchedPoints: [],
                isReadyToBeActivated: true,
                isActivated: true
            )
        )
    )
}
#endif

