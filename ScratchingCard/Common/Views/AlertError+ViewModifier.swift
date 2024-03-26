//
//  AlertError+ViewModifier.swift
//  ScratchingCard
//
//  Created by Raul Batista on 26.03.2024.
//

import SwiftUI

struct AlertErrorModifier: ViewModifier {
    let error: AlertError?
    
    private let primaryButton: Alert.Button
    private let secondaryButton: Alert.Button?

    init(
        error: AlertError?,
        primaryButton: Alert.Button,
        secondaryButton: Alert.Button?
    ) {
        self.error = error
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }

    func body(content: Content) -> some View {
        content
            .alert(isPresented: .constant(error != nil)
            ) {
                if let secondaryButton {
                    Alert(
                        title: Text(error?.localizedTitle ?? ""),
                        message: Text(error?.localizedMessage ?? ""),
                        primaryButton: primaryButton,
                        secondaryButton: secondaryButton
                    )
                } else {
                    Alert(
                        title: Text(error?.localizedTitle ?? ""),
                        message: Text(error?.localizedMessage ?? ""),
                        dismissButton: primaryButton
                    )
                }
            }
    }
}

// MARK: - View func to show error
extension View {
    func alertError(
        error: AlertError?,
        primaryButton: Alert.Button,
        secondaryButton: Alert.Button? = nil
    ) -> some View {
        modifier(
            AlertErrorModifier(
                error: error,
                primaryButton: primaryButton,
                secondaryButton: secondaryButton
            )
        )
    }
}
