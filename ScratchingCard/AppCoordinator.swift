//
//  AppCoordinator.swift
//  ScratchingCard
//
//  Created by Raul Batista on 23.03.2024.
//

import UIKit

typealias ActiveScene = (scene: UIScene, coordinatorId: ObjectIdentifier?)

@MainActor
final class AppCoordinator {
    var childCoordinators = [Coordinator]()

    private(set) lazy var activeScenes: [ActiveScene] = []

}

// MARK: - AppCoordinating

extension AppCoordinator: AppCoordinating {
    func start() {}
}

// MARK: Scenes management
extension AppCoordinator {
    func didLaunchScene<Coordinator: SceneCoordinating>(
        _ scene: UIScene,
        window: UIWindow
    ) -> Coordinator {
        let coordinator: Coordinator = makeSceneCoordinator(with: window)

        activeScenes.append((scene: scene, coordinatorId: ObjectIdentifier(coordinator)))
        childCoordinators.append(coordinator)

        return coordinator
    }

    func didDisconnectScene(_ scene: UIScene) {
        removeSceneCoordinator(for: scene)
    }
}

// MARK: Coordinators management
private extension AppCoordinator {
    func makeSceneCoordinator<Coordinator: SceneCoordinating>(with window: UIWindow) -> Coordinator {
        Coordinator(window: window)
    }

    func removeSceneCoordinator(for scene: UIScene) {
        guard let index = activeScenes.firstIndex(where: { $0.scene == scene }) else {
            return
        }

        let coordinatorId = activeScenes[index].coordinatorId

        // Remove coordinator from child coordinators
        if let index = childCoordinators.firstIndex(where: { ObjectIdentifier($0) == coordinatorId }) {
            childCoordinators.remove(at: index)
        }

        // Remove the scene from the list of active scenes
        activeScenes.remove(at: index)
    }
}
