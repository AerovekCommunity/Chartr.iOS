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
