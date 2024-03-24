//
//  MainScreenViewModel.swift
//  ScratchingCard
//
//  Created by Raul Batista on 24.03.2024.
//

import Combine
import SwiftUI

final class MainScreenViewModel: ObservableObject {
    enum MainScreenAction {
        case navigateToScratchScreen
        case navigateToActivationScreen
    }

    enum ViewAction {
        case dragGestureLocationChanged(CGPoint)
        case didFinishDragGesture
        case openScratchScreen
        case openActivationScreen
    }

    @Published var scratchedPoints = [CGPoint]()
    @Published var isCardActivated: Bool = false
    @Published var error: Error?
    let couponCode = UUID().uuidString

    private let eventSubject = PassthroughSubject<MainScreenAction, Never>()

    func bind() {
        if
            let storedPoints = UserDefaults.standard.data(forKey: Constants.scratchedPointsKey),
            let decodedData = try? JSONDecoder().decode([CGPoint].self, from: storedPoints) {
            scratchedPoints = decodedData
        }
    }

    func send(action: ViewAction) {
        switch action {
        case .openScratchScreen:
            // TODO: - open scratch screen
            break
        case .openActivationScreen:
            guard isCardActivated else {
                error = MainScreenError.cardAlreadyActivated
                return
            }
            // TODO: - open activation screen
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
        }
    }

    enum MainScreenError: LocalizedError {
        case cardAlreadyActivated

        var localizedDescription: String {
            switch self {
            case .cardAlreadyActivated:
                "This coupon has been already redeemed"
            }
        }
    }
}

extension MainScreenViewModel {
    var eventPublisher: AnyPublisher<MainScreenAction, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}


#if DEBUG
extension MainScreenViewModel {
    static let mockModel = MainScreenViewModel()
}
#endif
