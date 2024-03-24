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
        ScratchCardView(
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
        .onAppear {
            viewModel.bind()
        }
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
