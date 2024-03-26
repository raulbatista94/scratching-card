//
//  MainScreenViewModel.swift
//  ScratchingCard
//
//  Created by Raul Batista on 24.03.2024.
//

import Combine
import SwiftUI

final class MainScreenViewModel: ObservableObject {
    // MARK: - Public properties
    @Published var scratchedPoints = [CGPoint]()
    @Published var isCardReadyToBeActivated: Bool = false
    @Published var isActivated: Bool = false
    @Published var error: Error?
    @Published var id = UUID().uuidString

    // MARK: - Private properties
    private let eventSubject = PassthroughSubject<MainScreenAction, Never>()
    
    func send(action: ViewAction) {
        switch action {
        case .viewDidAppear:
            if
                let storedPoints = UserDefaults.standard.data(forKey: Constants.scratchedPointsKey),
                let cardStateModel = try? JSONDecoder().decode(CardStateModel.self, from: storedPoints) {
                scratchedPoints = cardStateModel.scratchedPoints
                isCardReadyToBeActivated = cardStateModel.isReadyToBeActivated
                id = cardStateModel.id
                isActivated = cardStateModel.isActivated
            }
        case .openScratchScreen:
            eventSubject.send(.navigateToScratchScreen(
                CardStateModel(
                    id: id,
                    scratchedPoints: scratchedPoints,
                    isReadyToBeActivated: isCardReadyToBeActivated,
                    isActivated: isActivated
                )
            ))
        case .openActivationScreen:
            guard !isActivated else {
                resetCardInfo()
                return
            }
            eventSubject.send(.navigateToActivationScreen(
                CardStateModel(
                    id: id,
                    scratchedPoints: scratchedPoints,
                    isReadyToBeActivated: isCardReadyToBeActivated,
                    isActivated: isActivated
                )
            ))
        }
    }

    private func resetCardInfo() {
        UserDefaults.standard.removeObject(forKey: Constants.scratchedPointsKey)
        guard
            UserDefaults.standard.synchronize(),
            UserDefaults.standard.object(forKey: Constants.scratchedPointsKey) == nil
        else {
            print("❌ Failed to remove the data from User defaults")
            return
        }

        scratchedPoints = []
        isCardReadyToBeActivated = false
        isActivated = false
    }
}

extension MainScreenViewModel {
    var eventPublisher: AnyPublisher<MainScreenAction, Never> {
        eventSubject.eraseToAnyPublisher()
    }

    enum MainScreenAction {
        case navigateToScratchScreen(CardStateModel)
        case navigateToActivationScreen(CardStateModel)
    }

    enum ViewAction {
        case viewDidAppear
        case openScratchScreen
        case openActivationScreen
    }
}


#if DEBUG
extension MainScreenViewModel {
    static let mockModel = MainScreenViewModel()
}
#endif
