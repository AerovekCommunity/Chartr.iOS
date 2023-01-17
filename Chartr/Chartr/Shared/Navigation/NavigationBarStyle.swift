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
