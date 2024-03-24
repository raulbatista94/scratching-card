//
//  NavigationControllerCoordinating.swift
//  ScratchingCarg
//
//  Created by Raul Batista on 23.03.2024.
//

import UIKit

protocol NavigationControllerCoordinator: ViewControllerCoordinator {
    var navigationController: UINavigationController { get }
}

extension NavigationControllerCoordinator {
    var rootViewController: UIViewController {
        navigationController
    }
}
