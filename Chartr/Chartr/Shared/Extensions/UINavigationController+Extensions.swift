/*
The MIT License (MIT)

Copyright (c) 2023-present Aerovek

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

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
