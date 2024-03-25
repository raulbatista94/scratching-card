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
        case navigateToScratchScreen(CardStateModel)
        case navigateToActivationScreen(CardStateModel)
    }
    
    enum ViewAction {
        case viewDidAppear
        case openScratchScreen
        case openActivationScreen
    }
    
    @Published var scratchedPoints = [CGPoint]()
    @Published var isCardReadyToBeActivated: Bool = false
    @Published var error: Error?
    @Published var id = UUID().uuidString

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
            }
        case .openScratchScreen:
            eventSubject.send(.navigateToScratchScreen(
                CardStateModel(
                    id: id,
                    scratchedPoints: scratchedPoints,
                    isReadyToBeActivated: isCardReadyToBeActivated
                )
            ))
        case .openActivationScreen:
            eventSubject.send(.navigateToActivationScreen(
                CardStateModel(
                    id: id,
                    scratchedPoints: scratchedPoints,
                    isReadyToBeActivated: isCardReadyToBeActivated
                )
            ))
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
