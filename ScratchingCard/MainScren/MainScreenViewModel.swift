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
        case viewDidAppear
        case openScratchScreen
        case openActivationScreen
    }
    
    @Published var scratchedPoints = [CGPoint]()
    @Published var isCardActivated: Bool = false
    @Published var error: Error?
    
    let couponCode = UUID().uuidString
    
    private let eventSubject = PassthroughSubject<MainScreenAction, Never>()
    
    func send(action: ViewAction) {
        switch action {
        case .viewDidAppear:
            if
                let storedPoints = UserDefaults.standard.data(forKey: Constants.scratchedPointsKey),
                let decodedData = try? JSONDecoder().decode([CGPoint].self, from: storedPoints) {
                scratchedPoints = decodedData
            }
        case .openScratchScreen:
            eventSubject.send(.navigateToScratchScreen)
        case .openActivationScreen:
            eventSubject.send(.navigateToActivationScreen)
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
