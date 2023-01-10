//
//  NavigableViewController.swift
//  Chartr
//
//  Created by Jay Martinez on 6/7/22.
//

import UIKit

protocol NavigableViewController {
    var navBarStyle: NavigationBarStyle { get }
    var navBarTitle: String? { get }
    var navigationItem: UINavigationItem { get }
    var leftBarButtonItemStyle: BarButtonItemStyle { get }
    var rightBarButtonItemStyle: BarButtonItemStyle { get }
    func action(for item: BarButtonItemStyle) -> Selector?
}

/// Default implementation
extension NavigableViewController where Self: UIViewController {
    var leftBarButtonItemStyle: BarButtonItemStyle {
        return .back
    }
    var rightBarButtonItemStyle: BarButtonItemStyle {
        return .none
    }
    
    var navBarTitle: String? {
        return nil
    }
    
    func action(for item: BarButtonItemStyle) -> Selector? {
        switch item {
        case .back, .close:
            return #selector(popController)
        default: return nil
        }
    }
}
