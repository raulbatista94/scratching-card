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
        ChildSizeReader(size: $viewModel.cardSize) {
            CardView(
                couponCode: viewModel.couponCode,
                scratchedPoints: $viewModel.scratchedPoints
            )
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged {
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
        .shadow(radius: 15)
        .modifier(AnimatedBackgroundModifier())
    }
}

#if DEBUG
#Preview {
    ScratchingView(viewModel: ScratchingViewModel())
}
#endif
