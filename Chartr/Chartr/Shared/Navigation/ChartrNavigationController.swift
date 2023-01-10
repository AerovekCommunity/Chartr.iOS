//
//  ChartrNavigationController.swift
//  Chartr
//
//  Created by Jay Martinez on 6/7/22.
//

import UIKit

class ChartrNavigationController: UINavigationController, UIViewControllerTransitioningDelegate {
    var topNavStyle: NavigationBarStyle = .clear
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topNavStyle == .dark ? .lightContent : .default
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: true)
        updateNavigationBar()
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        updateNavigationBar()
    }
    
    func updateNavigationBar() {
        guard let topController = self.topViewController as? NavigableViewController else { return }
        topNavStyle = topController.navBarStyle
        setNeedsStatusBarAppearanceUpdate()
        configureNavBar(with: topController.navBarStyle)
    }
}
