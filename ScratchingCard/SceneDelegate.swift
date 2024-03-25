//
//  SceneDelegate.swift
//  ScratchingCard
//
//  Created by Raul Batista on 23.03.2024.
//

import Combine
import Foundation
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    // swiftlint:disable:next implicitly_unwrapped_optional
    weak var coordinator: MainScreenCoordinator!

    private lazy var cancellables = Set<AnyCancellable>()

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        setupInitialScene(with: windowScene)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        appCoordinator.didDisconnectScene(scene)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        coordinator?.sceneWillEnterForeground(scene)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        coordinator?.sceneDidEnterBackground(scene)
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {

    }
}

// MARK: - Private
private extension SceneDelegate {
    func setupInitialScene(with windowScene: UIWindowScene) {
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.window?.overrideUserInterfaceStyle = .light

        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .purple

        coordinator = appCoordinator.didLaunchScene(windowScene, window: window)
        coordinator.start()
    }
}

extension UISceneDelegate {
    var appCoordinator: AppCoordinating {
        guard let delegate = UIApplication.shared.delegate as? AppCoordinatorContaining else {
            fatalError("Application delegate doesn't implement `AppCoordinatorDelegating` protocol")
        }

        return delegate.coordinator
    }
}


protocol AppCoordinatorContaining {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var coordinator: AppCoordinating! { get }
}

