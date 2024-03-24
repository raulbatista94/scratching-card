//
//  ViewControllerCoordinator.swift
//  ScratchingCarg
//
//  Created by Raul Batista on 23.03.2024.
//

import UIKit

/// A coordinator protocol which contains `rootViewController`.
/// UIViewController-based coordinators confirm to this.
/// Coordinators which handles transition inside custom content view controllers (view controllers with childVCs) should conform to this.
protocol ViewControllerCoordinator: Coordinator {
    var rootViewController: UIViewController { get }
}
