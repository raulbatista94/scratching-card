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
//    private var cardSize: CGSize?
    private let eventSubject = PassthroughSubject<ScratchingViewAction, Never>()

    func send(action: ViewAction) {
        switch action {
        case .viewDidAppear:
            if
                let storedPoints = UserDefaults.standard.data(forKey: Constants.scratchedPointsKey),
                let decodedData = try? JSONDecoder().decode([CGPoint].self, from: storedPoints) {
                scratchedPoints = decodedData
            }
        case let .updateScratchCardViewSize(size):
            cardSize = size
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

    private func evaluateCompletion() -> Bool {
        let coordinatesX = scratchedPoints.map(\.x)
        let coordinatesY = scratchedPoints.map(\.y)
        
        return coordinatesX.contains { 0...50 ~= $0 }
        && coordinatesY.contains { 0...50 ~= $0 }
        && coordinatesY.contains { cardSize.height - 50...cardSize.height ~= $0 }
        && coordinatesX.contains { cardSize.width - 50...cardSize.width ~= $0 }

    }
}

// MARK: - Actions
extension ScratchingViewModel {
    enum ScratchingViewAction {
        case dismiss
    }

    enum ViewAction {
        case viewDidAppear
        case updateScratchCardViewSize(CGSize)
        case dragGestureLocationChanged(CGPoint)
        case didFinishDragGesture
        case didTapDismiss
    }
}

extension ScratchingViewModel {
    var eventPublisher: AnyPublisher<ScratchingViewAction, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}
