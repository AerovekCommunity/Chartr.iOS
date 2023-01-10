//
//  ButtonStyle.swift
//  Chartr
//
//  Created by Jay Martinez on 6/9/22.
//

import UIKit

enum ButtonStyle: String {
    case primary
    case secondary
    case link
    case roundSmall
    case system
    
    var backgroundColor: UIColor {
        switch self {
        case .primary, .system: return AppColor.black.color
        case .secondary, .link: return .clear
        case .roundSmall: return AppColor.aeroBlue.color
        }
    }
    
    var backgroundColorDisabled: UIColor {
        switch self {
        case .primary, .system, .roundSmall: return AppColor.disabledGrey.color
        default: return .clear
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .primary, .system, .roundSmall: return AppColor.white.color
        case .secondary: return AppColor.black.color
        case .link: return AppColor.aeroBlue.color
        }
    }
    
    var intrinsicHeight: CGFloat? {
        switch self {
        case .primary, .system: return ControlSizing.primaryButtonHeight.value
        case .secondary: return ControlSizing.secondaryButtonHeight.value
        case .roundSmall: return ControlSizing.roundButtonSmallHeight.value
        case .link: return ControlSizing.linkButtonHeight.value
        }
    }
    
    var buttonWidth: CGFloat? {
        switch self {
        case .roundSmall: return ControlSizing.roundButtonSmallWidth.value
        default: return nil
        }
    }
    
    var textStyle: TextStyle? {
        switch self {
        case .primary, .system, .secondary: return .title
        case .roundSmall: return .body
        case .link: return .link
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .primary: return 1
        case .secondary: return 2
        default: return 0
        }
    }
    
    func cornerRadius(in rect: CGRect) -> CGFloat? {
        switch self {
        case .primary, .secondary: return ControlSizing.cornerRadiusStandard.value
        case .system: return ControlSizing.cornerRadiusLarge.value
        case .roundSmall: return ControlSizing.roundButtonSmallHeight.value / 2
        default: return nil
        }
    }
    
    var borderColor: CGColor? {
        switch self {
        case .primary: return AppColor.black.color.cgColor
        case .secondary: return AppColor.aeroBlue.color.cgColor
        case .link: return UIColor.clear.cgColor
        default: return nil
        }
    }
    
    var activityIndicatorStyle: UIActivityIndicatorView.Style {
        switch self {
        case .primary, .system, .secondary, .link, .roundSmall: return .medium
        }
    }
}
