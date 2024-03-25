//
//  ScratchCardView.swift
//  ScratchingCard
//
//  Created by Raul Batista on 24.03.2024.
//

import SwiftUI

struct ScratchCardView: View {
    @Binding var scratchedPoints: [CGPoint]
    private let couponCode: String
    init(
        couponCode: String,
        scratchedPoints: Binding<[CGPoint]>
    ) {
        self.couponCode = couponCode
        self._scratchedPoints = scratchedPoints
    }

    var body: some View {
        ZStack {
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(
                        colors: [
                            Color(red: 0/255, green: 148/255, blue: 213/255),
                            Color(red: 9/255, green: 41/255, blue: 93/255),
                            Color(red: 2/255, green: 44/255, blue: 89/255)
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
                    .foregroundStyle(Color.black)
                Text(couponCode)
                    .foregroundStyle(Color.black)
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
                    path.addLines(scratchedPoints)
                }
                    .stroke(style: StrokeStyle(
                        lineWidth: 20,
                        lineCap: .round,
                        lineJoin: .round)
                    )
            )
        }
    }
}

#if DEBUG
#Preview {
    ScratchCardView(
        couponCode: UUID().uuidString,
        scratchedPoints: .constant([])
    )
}
#endif
