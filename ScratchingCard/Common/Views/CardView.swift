//
//  CardView.swift
//  ScratchingCard
//
//  Created by Raul Batista on 24.03.2024.
//

import SwiftUI

struct CardView: View {
    @Binding var scratchedPoints: [CGPoint]
    @Binding var shouldRevealCode: Bool
    
    @State var showingCode: Bool = false

    // MARK: - Private properties
    private let couponCode: String

    init(
        couponCode: String,
        shouldRevealCode: Binding<Bool>,
        scratchedPoints: Binding<[CGPoint]>
    ) {
        self.couponCode = couponCode
        self._shouldRevealCode = shouldRevealCode
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
            .frame(height: 200)
            .frame(maxWidth: .infinity)

            VStack {
                Image(systemName: "apple.logo")
                    .resizable()
                    .frame(height: 40)
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(Color.black)
                Text(couponCode)
                    .foregroundStyle(Color.black)
                    .minimumScaleFactor(0.7)
                    .padding(.horizontal)
            }
            .frame(height: 200)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
            )
            .if(!showingCode) {
                $0.mask(
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
            .onChange(of: shouldRevealCode) {
                if $0 {
                    withAnimation(.linear(duration: 0.3)) {
                        self.showingCode = true
                    }
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    CardView(
        couponCode: UUID().uuidString,
        shouldRevealCode: .constant(false),
        scratchedPoints: .constant([])
    )
}
#endif
