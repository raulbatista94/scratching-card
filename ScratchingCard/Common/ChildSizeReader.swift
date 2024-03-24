//
//  ChildSizeReader.swift
//  ScratchingCard
//
//  Created by Raul Batista on 24.03.2024.
//

import SwiftUI

/// ChildSizeReader reads the size of its children by encapsulating them
public struct ChildSizeReader<Content: View> {
    // MARK: Properties
    @Binding public var size: CGSize
    let content: Content

    // MARK: Init
    public init(size: Binding<CGSize>, @ViewBuilder _ content: () -> Content) {
        _size = size
        self.content = content()
    }
}

// MARK: View
extension ChildSizeReader: View {
    public var body: some View {
        ZStack {
            content
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: SizePreferenceKey.self, value: proxy.size)
                    }
                )
        }
        .onPreferenceChange(SizePreferenceKey.self) { preferences in
            self.size = preferences
        }
    }
}

// MARK: SizePreferenceKey
struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: Value = .zero

    static func reduce(value _: inout Value, nextValue: () -> Value) {
        _ = nextValue()
    }
}
