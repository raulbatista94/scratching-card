//
//  ActivationViewModel.swift
//  ScratchingCard
//
//  Created by Raul Batista on 25.03.2024.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class ActivationViewModel: ObservableObject {
    enum ViewAction {
        case didTapActivate
        case didTapDismiss
        case dismissError
    }

    enum ActivationViewAction {
        case dismiss
    }

    // MARK: - Public properties
    let cardState: CardStateModel
    @Published var error: AlertError?
    @Published var isLoading: Bool = false
    @Published var isActivated: Bool
    @Injected private var apiManager: APIManaging

    // MARK: - Private properties
    private let eventSubject = PassthroughSubject<ActivationViewAction, Never>()

    init(cardState: CardStateModel) {
        self.cardState = cardState
        self.isActivated = cardState.isActivated
    }

    func send(action: ViewAction) {
        switch action {
        case .didTapActivate:
            Task { [weak self] in
                guard let self else {
                    return
                }

                isLoading = true

                let endpoint = CodeActivationRouter.activateCode(code: cardState.id)

                if let response: RemoteResponseDTO = try? await apiManager.request(endpoint),
                   let iOSValue = response.ios,
                   let numericValue = Double(iOSValue),
                   numericValue > 6.1 {
                    isActivated = true
                    isLoading = false
                    storeActivatedCardInfo()
                } else {
                    error = ActivationViewError.failedToActivateCode
                }
            }
        case .didTapDismiss:
            eventSubject.send(.dismiss)
        case .dismissError:
            isLoading = false
            error = nil
        }
    }
}

// MARK: - Private API
private extension ActivationViewModel {
    func storeActivatedCardInfo() {
        do {
            let cardState = CardStateModel(
                id: cardState.id,
                scratchedPoints: cardState.scratchedPoints,
                isReadyToBeActivated: cardState.isReadyToBeActivated,
                isActivated: isActivated
            )
            let data = try JSONEncoder().encode(cardState)
            UserDefaults.standard.set(data, forKey: Constants.scratchedPointsKey)
        } catch {
            self.error = ActivationViewError.failedToStoreCardInfo
        }
    }
}

// MARK: - Utils
extension ActivationViewModel {
    var eventPublisher: AnyPublisher<ActivationViewAction, Never> {
        eventSubject.eraseToAnyPublisher()
    }

    enum ActivationViewError: AlertError {
        case failedToActivateCode
        case failedToStoreCardInfo

        var localizedTitle: String {
            switch self {
            case .failedToActivateCode, .failedToStoreCardInfo:
                String(localized: "activationView.errorTitle")
            }
        }
        var localizedMessage: String {
            switch self {
            case .failedToActivateCode:
                String(localized: "activationView.errorMessage")
            case .failedToStoreCardInfo:
                String(localized: "activationView.storeInfoErrorMessage")
            }
        }
    }
}
