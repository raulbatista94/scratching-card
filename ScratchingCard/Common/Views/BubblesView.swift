//
//  BubblesView.swift
//  ScratchingCard
//
//  Created by Raul Batista on 25.03.2024.
//

import SwiftUI

struct Bubble: View {
    @State private var isAnimating = false

    var body: some View {
        Circle()
            .stroke(lineWidth: 2)
            .frame(width: 50, height: 50)
            .opacity(CGFloat.random(in: 0.08...0.2))
            .foregroundColor(.white)
            .offset(
                y: isAnimating ? -CGFloat.random(in: 1...UIScreen.main.bounds.height) : 0)
            .onAppear() {
                withAnimation(
                    .linear(duration: 60)
                    .repeatForever(autoreverses: true)
                ) {
                    self.isAnimating = true
                }
            }
    }
}

struct BubbleAnimationView: View {
    var body: some View {
        ZStack {
            ForEach(0..<50) { _ in
                Bubble()
                    .position(
                        x: CGFloat.random(in: 1...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 1...UIScreen.main.bounds.height)
                    )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BubbleAnimationView()
    }
}
