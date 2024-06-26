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
    // MARK: - Public properties
    @Published var scratchedPoints = [CGPoint]()
    @Published var isCompletelyScratched: Bool = false
    @Published var error: Error?
    @Published var isLoading: Bool = false
    @Published var id: String = UUID().uuidString

    @Published var cardSize: CGSize = .zero

    // MARK: - Private properties
    private let eventSubject = PassthroughSubject<ScratchingViewAction, Never>()
    private var revealTask: Task<Void, Never>?

    init(cardStateModel: CardStateModel) {
        scratchedPoints = cardStateModel.scratchedPoints
        isCompletelyScratched = cardStateModel.isReadyToBeActivated
        id = cardStateModel.id
    }

    func send(action: ViewAction) {
        switch action {
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
            storeCardInfo()
        case .didTapRevealCode:
            revealTask = Task.detached(operation: { [weak self] in
                guard let self else {
                    return
                }

                await toggleLoading()

                do {
                    // Act as if this was a heavy operation
                    try await Task.sleep(nanoseconds: 2_000_000_000)
                    await self.revealCard()
                    await self.storeCardInfo()
                    await toggleLoading()
                } catch {
                    await toggleLoading()
                }
            })

        case .didTapDismiss:
            revealTask?.cancel()
            eventSubject.send(.dismiss)
        }
    }

    private func toggleLoading() {
        isLoading.toggle()
    }
    private func revealCard() {
        isCompletelyScratched = true
    }

    // TODO: - This definitely should be improved and better logic should be added here cause
    // sometimes it just doesn't work as expected. Ideal would be create some kind of matrix of 0 and 1
    // where the values would be changed and when certain percentage is uncovered we would reveal the whole code.

    /// Evaluates if the scratched parts contain a radius of the corner coordinates of the card
    /// with some extra radius of 100 points.
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

        return -50...50 ~= minX
        && -50...50 ~= minY
        && (cardSize.height - 50)...(cardSize.height + 50) ~= maxY
        && (cardSize.width - 50)...(cardSize.width + 50) ~= maxX
    }
    
    /// Update card info
    private func storeCardInfo() {
        do {
            let cardState = CardStateModel(
                id: id,
                scratchedPoints: scratchedPoints,
                isReadyToBeActivated: isCompletelyScratched,
                isActivated: false
            )
            let data = try JSONEncoder().encode(cardState)
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
