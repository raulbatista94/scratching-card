//
//  AppDelegate.swift
//  ScratchingCard
//
//  Created by Raul Batista on 23.03.2024.
//

import Foundation
import UIKit

@MainActor
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }

    func start()
}

protocol SceneCoordinating: Coordinator {
    var window: UIWindow { get }
    init(window: UIWindow)
}

extension SceneCoordinating {
    @MainActor func setRootCoordinator(_ coordinator: ViewControllerCoordinator, animated: Bool = false) {
        childCoordinators = [coordinator]
        coordinator.start()

        window.rootViewController = coordinator.rootViewController
        window.makeKeyAndVisible()

        if animated {
            UIView.transition(
                with: window,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: nil,
                completion: nil
            )
        }
    }
}


protocol AppCoordinating: Coordinator {
    func didLaunchScene<Coordinator: SceneCoordinating>(
        _ scene: UIScene,
        window: UIWindow
    ) -> Coordinator

    func didDisconnectScene(_ scene: UIScene)
}

@main
class AppDelegate: NSObject, UIApplicationDelegate, AppCoordinatorContaining {
    var coordinator: AppCoordinating!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        coordinator = AppCoordinator()
        coordinator.start()

        return true
    }
}
