//
//  MainScreenCoordinator.swift
//  ScratchingCard
//
//  Created by Raul Batista on 23.03.2024.
//

import Combine
import Foundation
import UIKit
import SwiftUI


@MainActor
final class MainScreenCoordinator: SceneCoordinating {
    // MARK: - Public properties
    var childCoordinators = [Coordinator]()
    let window: UIWindow
    private(set) lazy var navigationController: UINavigationController = UINavigationController()

    // MARK: - Private properties
    private var cancellabes = Set<AnyCancellable>()

    nonisolated init(window: UIWindow) {
        self.window = window
    }
}

private extension MainScreenCoordinator {
    func setMainScreeView() {
        let viewModel = MainScreenViewModel()
        navigationController
            .setViewControllers([
                UIHostingController(
                    rootView: MainScreenView(viewModel: viewModel)
                )
            ], animated: false)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        viewModel.eventPublisher
            .sink { [weak self] action in
                guard let self else {
                    return
                }
                switch action {
                case let .navigateToActivationScreen(state):
                    navigationController.pushViewController(activationScreen(cardState: state), animated: true)
                case let .navigateToScratchScreen(state):
                    navigationController.pushViewController(scratchScreen(cardState: state), animated: true)
            }
        }
        .store(in: &cancellabes)
    }
}

// MARK: - App lifecycle
extension MainScreenCoordinator: AppLifecycleResponding {
    func didDisconnectScene(_ scene: UIScene) {
        childCoordinators.removeAll()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        childCoordinators
            .forEach { ($0 as? AppLifecycleResponding)?.sceneWillEnterForeground(scene) }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        childCoordinators
            .forEach { ($0 as? AppLifecycleResponding)?.sceneDidEnterBackground(scene) }
    }
}


// MARK: - Navigation to next screens
extension MainScreenCoordinator {
    func start() {
        setMainScreeView()
    }

    func scratchScreen(cardState: CardStateModel) -> UIViewController {
        let viewModel = ScratchingViewModel(cardStateModel: cardState)
        let view = ScratchingView(viewModel: viewModel)
        
        viewModel.eventPublisher
            .sink { [weak self] action in
                switch action {
                case .dismiss:
                    self?.navigationController.popViewController(animated: true)
                }
            }
            .store(in: &cancellabes)

        return HostingController(
            rootView: view,
            configuration: .init(
                hidesBackButton: true,
                hidesNavigationBar: true)
        )
    }

    func activationScreen(cardState: CardStateModel) -> UIViewController {
        let viewModel = ActivationViewModel(cardState: cardState)
        let view = ActivationView(viewModel: viewModel)

        viewModel.eventPublisher
            .sink { [weak self] action in
                switch action {
                case .dismiss:
                    self?.navigationController.popViewController(animated: true)
                }
            }
            .store(in: &cancellabes)

        return HostingController(
            rootView: view,
            configuration: .init(
                hidesBackButton: true,
                hidesNavigationBar: true)
        )
    }
}

