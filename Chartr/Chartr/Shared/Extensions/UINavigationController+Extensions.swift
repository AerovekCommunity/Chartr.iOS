//
//  UINavigationController+Extensions.swift
//  Chartr
//
//  Created by Jay Martinez on 6/13/22.
//

import UIKit

extension UINavigationController {
    func configureNavBar(with style: NavigationBarStyle) {
        switch style {
        case .light, .dark, .white, .clear:
            navigationBar.isOpaque = true
            navigationBar.isTranslucent = false
            
            if style.barTintColor == .clear {
                navigationBar.barTintColor = topViewController?.view.backgroundColor
            } else {
                navigationBar.barTintColor = style.barTintColor
            }
            
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: style.barTextColor]
            navigationBar.tintColor = style.barTextColor
            
            // Workaround for iOS 15+, see this post https://developer.apple.com/forums/thread/682420
            if #available(iOS 15.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = navigationBar.barTintColor
                
                if let textAttrs = navigationBar.titleTextAttributes {
                    appearance.titleTextAttributes = textAttrs
                } else {
                    appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: style.barTextColor]
                }
                
                navigationBar.standardAppearance = appearance
                navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
            }
            
            // If a VC implements the NavigableViewController protocol we will see if the bar button related
            // methods and styles were defined then apply them now
            guard let topController = self.topViewController as? NavigableViewController else { return }
            if let action = topController.action(for: topController.leftBarButtonItemStyle),
                let leftBarButtonItem = topController.leftBarButtonItemStyle.barButtonItem(action: action, target: topController) {
                topController.navigationItem.setHidesBackButton(true, animated: false)
                topController.navigationItem.setLeftBarButtonItems([leftBarButtonItem], animated: true)
            } else {
                topController.navigationItem.setLeftBarButtonItems([], animated: true)
            }

            if let action = topController.action(for: topController.rightBarButtonItemStyle),
                let rightBarButtonItem = topController.rightBarButtonItemStyle.barButtonItem(action: action, target: topController) {
                topController.navigationItem.setRightBarButtonItems([rightBarButtonItem], animated: true)
            } else {
                topController.navigationItem.setRightBarButtonItems([], animated: true)
            }
            
            if let title = topController.navBarTitle {
                topController.navigationItem.title = title
            }
            
        case .hidden:
            setNavigationBarHidden(true, animated: true)
            return
        }
        
        // show bar if necessary
        if isNavigationBarHidden {
            setNavigationBarHidden(false, animated: true)
        }
        
        //guard let topController = self.topViewController as? NavigableViewController else { return }
        view.backgroundColor = navigationBar.barTintColor
    }
}
