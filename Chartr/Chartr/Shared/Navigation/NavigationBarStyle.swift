//
//  NavigationBarStyle.swift
//  Chartr
//
//  Created by Jay Martinez on 6/7/22.
//

import UIKit

enum NavigationBarStyle {
    case hidden
    case dark
    case light
    case white
    case clear
    
    var barTextColor: UIColor {
        switch self {
        case .hidden, .white, .light, .clear: return AppColor.aeroBlue.color
        case .dark: return AppColor.white.color
        }
    }
    
    var barTintColor: UIColor {
        switch self {
        case .dark: return AppColor.black.color
        case .hidden, .clear: return .clear
        case .white, .light: return AppColor.white.color
        }
    }
    
    var buttonTintColor: UIColor {
        if self == .dark {
            return AppColor.white.color
        }
        
        return AppColor.black.color
    }
    
    var hideShadow: Bool {
        switch self {
        case .dark, .light, .hidden, .white: return false
        case .clear: return true
        }
    }
}
