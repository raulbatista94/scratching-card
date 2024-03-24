//
//  InitialSceneCoordinator.swift
//  ScratchingCarg
//
//  Created by Raul Batista on 23.03.2024.
//

import Foundation
import UIKit
import SwiftUI

protocol AppLifecycleResponding {
    func sceneWillEnterForeground(_ scene: UIScene)
    func sceneDidEnterBackground(_ scene: UIScene)
}

@MainActor
final class InitialSceneCoordinator: SceneCoordinating {
    var childCoordinators = [Coordinator]()
    let window: UIWindow
    private(set) lazy var navigationController: UINavigationController = UINavigationController()

    init(window: UIWindow) {
        self.window = window
    }
}

private extension InitialSceneCoordinator {
    func setLaunchscreenWindow() {
        window.rootViewController = UIHostingController(rootView: UIViewController())
        window.makeKeyAndVisible()
    }

    func goToMainMenu() {

    }
}

extension InitialSceneCoordinator: AppLifecycleResponding {
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


extension InitialSceneCoordinator {
    func start() {
        setLaunchscreenWindow()
        // TOOD: At this point we will check if we will
        // open the main menu or continue game.
        goToMainMenu()

    }
}

