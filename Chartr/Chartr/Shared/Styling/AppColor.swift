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

enum AppColor: String {
    case black
    case textRegular
    case textLight
    case disabledGrey
    case aeroBlue
    case backgroundGrey
    case backgroundDarkGrey
    case white
    case warning
    case green
    case yellow
    
    var color: UIColor {
        switch self {
        case .black: return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case .backgroundGrey: return #colorLiteral(red: 0.9764705882, green: 0.9725490196, blue: 0.968627451, alpha: 1)
        case .backgroundDarkGrey: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        case .aeroBlue: return #colorLiteral(red: 0.0431372549, green: 0.4274509804, blue: 1, alpha: 1)
        case .disabledGrey: return #colorLiteral(red: 0.7820063233, green: 0.7722578049, blue: 0.7723029256, alpha: 1)
        case .textLight: return #colorLiteral(red: 0.9411764706, green: 0.9333333333, blue: 0.9215686275, alpha: 1)
        case .textRegular: return #colorLiteral(red: 0.4156862745, green: 0.4156862745, blue: 0.4156862745, alpha: 1)
        case .white: return .white
        case .warning: return #colorLiteral(red: 0.9529411793, green: 0.4685409219, blue: 0, alpha: 1)
        case .yellow: return #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        case .green: return #colorLiteral(red: 0, green: 0.5853648929, blue: 0.06956988043, alpha: 1)
        }
    }
}
