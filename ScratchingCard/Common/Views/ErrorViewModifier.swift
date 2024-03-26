//
//  ErrorViewModifier.swift
//  ScratchingCard
//
//  Created by Raul Batista on 25.03.2024.
//

import SwiftUI

// swiftlint:disable file_types_order
public struct ErrorViewModifier: ViewModifier {
    private let errorTitle: String
    private let errorMessage: String

    private var primaryButton: Alert.Button
    private var secondaryButton: Alert.Button?

    private let error: Error?

    public init(
        title: String,
        error: LocalizedError?,
        primaryButton: Alert.Button,
        secondaryButton: Alert.Button?
    ) {
        self.errorTitle = title
        self.error = error
        self.errorMessage = error?.localizedDescription ?? ""
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }

    public func body(content: Content) -> some View {
        content
            .alert(
                isPresented: .constant(error != nil)
            ) {
                if let secondaryButton {
                    Alert(
                        title: Text(errorTitle),
                        message: Text(errorMessage),
                        primaryButton: primaryButton,
                        secondaryButton: secondaryButton
                    )
                } else {
                    Alert(
                        title: Text(errorTitle),
                        message: Text(errorMessage),
                        dismissButton: primaryButton
                    )
                }
            }
    }
}

// MARK: View
public extension View {
    func alertError(
        title: String,
        error: LocalizedError?,
        primaryButton: Alert.Button,
        secondaryButton: Alert.Button? = nil
    ) -> some View {
        modifier(
            ErrorViewModifier(
                title: title,
                error: error,
                primaryButton: primaryButton, 
                secondaryButton: secondaryButton)
        )
    }
}
