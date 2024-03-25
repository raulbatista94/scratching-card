//
//  ScratchingViewModel.swift
//  ScratchingCard
//
//  Created by Raul Batista on 25.03.2024.
//

import Combine
import Foundation
import SwiftUI

@MainActor
final class ScratchingViewModel: ObservableObject {
    // MARK: - Public porperties
    @Published var scratchedPoints = [CGPoint]()
    @Published var isCompletelyScratched: Bool = false
    @Published var error: Error?
    @Published var isLoading: Bool = false
    
    @Published var cardSize: CGSize = .zero
    let couponCode = UUID().uuidString

    // MARK: - Private properties
    private let eventSubject = PassthroughSubject<ScratchingViewAction, Never>()

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
            
            isCompletelyScratched = evaluateCompletion()

            guard !isCompletelyScratched else {
                UserDefaults.standard.removeObject(forKey: Constants.scratchedPointsKey)
                return
            }

            clearStoredCardInfo()

        case .didTapRevealCode:
            isCompletelyScratched = true
            clearStoredCardInfo()

        case .didTapDismiss:
            eventSubject.send(.dismiss)
        }
    }
    
    /// Evaluates if the scratched parts contain a radius of the corner coordinates of the card
    /// with some extra radius of 50 points.
    /// - Returns: `Bool` value indicating wether the code should be completely revealed.
    private func evaluateCompletion() -> Bool {
        guard
            let minX = scratchedPoints.map(\.x).min(),
            let maxX = scratchedPoints.map(\.x).max(),
            let minY = scratchedPoints.map(\.y).min(),
            let maxY = scratchedPoints.map(\.y).max()
        else {
            return false
        }

        return -25...25 ~= minX
        && -25...25 ~= minY
        && (cardSize.height - 25)...(cardSize.height + 25) ~= maxY
        && (cardSize.width - 25)...(cardSize.width + 25) ~= maxX
    }
    
    /// Removes stored information about scratched positions
    private func clearStoredCardInfo() {
        do {
            let data = try JSONEncoder().encode(scratchedPoints)
            UserDefaults.standard.set(data, forKey: Constants.scratchedPointsKey)
        } catch {
            self.error = error
        }
    }
}

// MARK: - Actions
extension ScratchingViewModel {
    enum ScratchingViewAction {
        case dismiss
    }

    enum ViewAction {
        case viewDidAppear
        case dragGestureLocationChanged(CGPoint)
        case didFinishDragGesture
        case didTapRevealCode
        case didTapDismiss
    }
}

extension ScratchingViewModel {
    var eventPublisher: AnyPublisher<ScratchingViewAction, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}
