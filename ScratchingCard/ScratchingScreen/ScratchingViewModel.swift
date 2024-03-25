//
//  ScratchingViewModel.swift
//  ScratchingCard
//
//  Created by Raul Batista on 25.03.2024.
//

import Combine
import Foundation
import SwiftUI

final class ScratchingViewModel: ObservableObject {
    @Published var scratchedPoints = [CGPoint]()
    @Published var isCardActivated: Bool = false
    @Published var error: Error?

    let couponCode = UUID().uuidString

    private let eventSubject = PassthroughSubject<ScratchingViewAction, Never>()

    enum ScratchingViewAction {
        case dismiss
    }

    enum ViewAction {
        case viewDidAppear
        case dragGestureLocationChanged(CGPoint)
        case didFinishDragGesture
        case didTapDismiss
    }

    func send(action: ViewAction) {
        switch action {
        case .viewDidAppear:
            if
                let storedPoints = UserDefaults.standard.data(forKey: Constants.scratchedPointsKey),
                let decodedData = try? JSONDecoder().decode([CGPoint].self, from: storedPoints) {
                scratchedPoints = decodedData
            }
        case let .dragGestureLocationChanged(location):
            let x = (location.x * 100).rounded() / 100
            let y = (location.y * 100).rounded() / 100
            let roundedLocation = CGPoint(x: x, y: y)

            guard !scratchedPoints.contains(roundedLocation) else {
                return
            }

            scratchedPoints.append(roundedLocation)
        case .didFinishDragGesture:
            do {
                let data = try JSONEncoder().encode(scratchedPoints)
                UserDefaults.standard.set(data, forKey: Constants.scratchedPointsKey)
            } catch {
                self.error = error
            }
        case .didTapDismiss:
            eventSubject.send(.dismiss)
        }
    }

    private func evaluateCompletion() {
        // TODO:
    }
}

extension ScratchingViewModel {
    var eventPublisher: AnyPublisher<ScratchingViewAction, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}
