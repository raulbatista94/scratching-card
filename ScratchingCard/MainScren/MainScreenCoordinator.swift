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
    var childCoordinators = [Coordinator]()
    let window: UIWindow
    
    private var cancellabes = Set<AnyCancellable>()

    private(set) lazy var navigationController: UINavigationController = UINavigationController()

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
                case .navigateToActivationScreen:
                    navigationController.pushViewController(scratchScreen(), animated: true)
                case .navigateToScratchScreen:
                    navigationController.pushViewController(scratchScreen(), animated: true)
            }
        }
        .store(in: &cancellabes)
    }
}

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


extension MainScreenCoordinator {
    func start() {
        setMainScreeView()
    }

    func scratchScreen() -> UIViewController {
        let viewModel = ScratchingViewModel()
        let view = ScratchingView(viewModel: viewModel)
        
        let controller = HostingController(
            rootView: view,
            configuration: .init(
                hidesBackButton: true,
                hidesNavigationBar: true)
        )

        return controller
    }
}

