//
//  HostingController.swift
//  ScratchingCard
//
//  Created by Raul Batista on 25.03.2024.
//

import Foundation
import SwiftUI
import UIKit

public final class HostingController<Content: View>: UIHostingController<Content>, UIGestureRecognizerDelegate {
    public struct Configuration {
        var title: String?
        var hidesBackButton: Bool
        var hidesNavigationBar: Bool
        let preferredStatusBarStyle: UIStatusBarStyle

        public init(
            title: String? = nil,
            hidesBackButton: Bool,
            hidesNavigationBar: Bool,
            preferredStatusBarStyle: UIStatusBarStyle = .darkContent
        ) {
            self.title = title
            self.hidesBackButton = hidesBackButton
            self.hidesNavigationBar = hidesNavigationBar
            self.preferredStatusBarStyle = preferredStatusBarStyle
        }
    }

    // MARK: Private Properties
    private let configuration: Configuration

    // MARK: Lifecycle

    public init(
        rootView: Content,
        configuration: Configuration = Configuration(
            title: nil,
            hidesBackButton: false,
            hidesNavigationBar: false
        )
    ) {
        self.configuration = configuration

        super.init(rootView: rootView)
        navigationItem.title = configuration.title
    }

    @available(*, unavailable)
    dynamic required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = configuration.hidesBackButton
        navigationController?.setNavigationBarHidden(
            configuration.hidesNavigationBar,
            animated: false
        )
        navigationItem.title = configuration.title
    }

    override public var preferredStatusBarStyle: UIStatusBarStyle {
        configuration.preferredStatusBarStyle
    }

    // https://stackoverflow.com/a/69359296/14044847
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.setNeedsUpdateConstraints()
        // we need to set it again, otherwise it will re-appear
        navigationItem.hidesBackButton = configuration.hidesBackButton
        navigationItem.title = configuration.title
    }
}

// MARK: - Setup UI

private extension HostingController {
    func setupUI() {
        setupView()
    }

    func setupView() {
        view.backgroundColor = .white
    }
}
