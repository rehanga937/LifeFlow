//
//  UINavigationBar.swift
//  LifeFlow_vishwa
//
//  Created by user239248 on 8/16/23.
//


import SwiftUI

extension UINavigationBar {
    static func setupCustomAppearance() {
        let backgroundColor = UIColor(red: 0.8392156959, green: 0.1215686277, blue: 0.1490196139, alpha: 1.0)
        let textColor = UIColor.white

        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = backgroundColor
        coloredAppearance.titleTextAttributes = [.foregroundColor: textColor]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: textColor]

        self.appearance().standardAppearance = coloredAppearance
        self.appearance().compactAppearance = coloredAppearance
        self.appearance().scrollEdgeAppearance = coloredAppearance
        self.appearance().tintColor = textColor
    }
}


struct NavigationBarAppearanceModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                UINavigationBar.setupCustomAppearance()
            }
    }
}
