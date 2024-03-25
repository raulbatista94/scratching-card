//
//  ScratchingView.swift
//  ScratchingCard
//
//  Created by Raul Batista on 24.03.2024.
//

import SwiftUI


struct ScratchingView: View {
    @ObservedObject var viewModel: ScratchingViewModel

    init(viewModel: ScratchingViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading) {
            backButton
                .padding(.leading)


            Spacer()

            cardView
            
            Spacer()

            Button("Reveal Code") {
                viewModel.send(action: .didTapRevealCode)
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal)
            .padding(.bottom)
        }
        .modifier(AnimatedBackgroundModifier())
    }
}

// MARK: - Subviews
private extension ScratchingView {
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
    }

    var cardView: some View {
        ChildSizeReader(size: $viewModel.cardSize) {
            CardView(
                couponCode: viewModel.couponCode,
                shouldRevealCode: $viewModel.isCompletelyScratched,
                scratchedPoints: $viewModel.scratchedPoints
            )
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged {
                        guard
                            $0.location.y <= viewModel.cardSize.height,
                            $0.location.x <= viewModel.cardSize.width
                        else {
                            return
                        }

                        viewModel.send(action: .dragGestureLocationChanged($0.location))
                    }
                    .onEnded { _ in
                        viewModel.send(action: .didFinishDragGesture)
                    }
            )
            .padding(.horizontal)
            .onAppear {
                // Would be better to send this action only once since we don't want to
                // perform this operation every time that the view appears. Could be done by implementing
                // view modifier `onFirstAppear` that would have a flag if the action already happened
                // so it's not fired more than once.
                viewModel.send(action: .viewDidAppear)
            }
        }
        .shadow(
            color: viewModel.isCompletelyScratched
            ? Color.green.opacity(0.4)
            : Color(.sRGBLinear, white: 0, opacity: 0.33),
            radius: 15
        )
    }
}

#if DEBUG
#Preview {
    ScratchingView(viewModel: ScratchingViewModel())
}
#endif
