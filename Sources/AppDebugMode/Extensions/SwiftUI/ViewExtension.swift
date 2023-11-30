//
//  ViewExtension.swift
//  
//
//  Created by Matus Klasovity on 26/06/2023.
//

import SwiftUI
import SwiftUIIntrospect

// MARK: - Keyboard

extension View {

    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }

    func dismissKeyboardOnDrag() -> some View {
        if #available(iOS 16, *) {
            return self
                .scrollDismissesKeyboard(.immediately)
        } else {
            return onAppear {
                UIScrollView.appearance().keyboardDismissMode = .onDrag
            }
            .onDisappear {
                UIScrollView.appearance().keyboardDismissMode = .none
            }
        }
    }

}

// MARK: - List view

extension View {
    
    /// Sets background color for list.
    /// ```
    ///    var body: some View {
    ///         List {
    ///
    ///           }
    ///           .listStyle(.insetGrouped)
    ///           .listBackgroundColor(.red, for: .insetGrouped)
    ///     }
    /// ```
    /// - Parameters:
    ///   - backgroundColor: Color used to set lists background.
    ///   - style: List style. Must be equal to the style of the list specified with  .listStyle().
    @available(iOS, introduced: 14, deprecated: 16, message: "Use .scrollContentBackground(.hidden) combined with .background() instead")
    func listBackgroundColor(_ backgroundColor: Color, for style: ListWithInsetGroupedStyleType.Style) -> some View {
        if #available(iOS 16, *) {
            return self
                .scrollContentBackground(.hidden)
                .background(backgroundColor)
        } else {
            return self
                .introspect(.list(style: style), on: .iOS(.v14, .v15)) { tableView in
                    tableView.backgroundColor = UIColor(AppDebugColors.backgroundPrimary)
                }
        }
    }
    
    func listRowSeparatorColor(_ color: Color, for style: ListWithInsetGroupedStyleType.Style) -> some View {
        if #available(iOS 15, *) {
            return self
                .listRowSeparatorTint(color)
        } else {
            return self
                .introspect(.list(style: .insetGrouped), on: .iOS(.v14), scope: .ancestor) { tableView in
                    tableView.separatorColor = UIColor(color)
                }
        }
    }
    
    /// This is a workaround for iOS 15.2 adn earlier. It will **have no effect on later iOS versions**. For these use safeAreaInset() instead.
    /// ```
    ///    var body: some View {
    ///         List {
    ///
    ///           }
    ///           .listStyle(.insetGrouped)
    ///           .listContentInsets(UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0), for: .insetGrouped)
    ///     }
    /// ```
    /// - Parameters:
    ///   - insets: Content insets that will be applied to the list.
    ///   - style: List style. Must be equal to the style of the list specified with  .listStyle().
    @available(iOS, introduced: 14, deprecated: 15.2, message: "Use safeAreaInset() instead")
    func listContentInsets(_ insets: UIEdgeInsets, for style: ListWithInsetGroupedStyleType.Style) -> some View {
        if #unavailable(iOS 15.2) {
            return self
                .introspect(.list(style: style), on: .iOS(.v14, .v15)) { tableView in
                    tableView.contentInset = insets
                }
        } else {
            return self
        }
    }
    
}

// MARK: - If

extension View {

    @ViewBuilder func `if`(_ condition: Bool, _ content: Function<Self, some View>) -> some View {
        if condition {
            content(self)
        } else {
            self
        }
    }
    
    @ViewBuilder func `if`(_ condition: Bool) -> some View {
        if condition {
            self
        }
    }
    
}
