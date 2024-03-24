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
        ZStack {
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(
                        colors: [
                            Color(red: 22/255, green: 83/255, blue: 182/255),
                            Color(red: 9/255, green: 41/255, blue: 93/255),
                            Color(red: 4/255, green: 25/255, blue: 61/255)
                        ],
                        startPoint: .top,
                        endPoint: .bottom)
                    )

                Text("Welcome to O2")
                    .font(.title2)
                    .foregroundStyle(Color.white)
            }
            .frame(width: 205, height: 205)

            VStack {
                Image(systemName: "apple.logo")
                Text(viewModel.couponCode)
                    .minimumScaleFactor(0.7)
                    .padding(.horizontal)
            }
            .frame(width: 200, height: 200)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .stroke(.black, style: StrokeStyle(lineWidth: 5))
            )
            .padding()
            .mask(
                Path { path in
                    path.addLines(viewModel.scratchedPoints)
                }
                .stroke(style: StrokeStyle(
                    lineWidth: 20,
                    lineCap: .round,
                    lineJoin: .round)
                )
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
        }
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
