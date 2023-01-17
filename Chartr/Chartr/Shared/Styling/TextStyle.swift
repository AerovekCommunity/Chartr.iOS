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

enum TextStyle: String {
    case headline
    case headlineBold
    case title
    case tiny
    case body
    case link
    
    var font: UIFont {
        switch self {
        case .title: return AppFont.primaryNormal.font(of: 18)
        case .link, .body: return AppFont.primaryNormal.font(of: 16)
        case .tiny: return AppFont.primaryThin.font(of: 14)
        case .headline: return AppFont.primaryNormal.font(of: 24)
        case .headlineBold: return AppFont.primaryHeavy.font(of: 24)
        }
    }
    
    var underlined: Bool {
        switch self {
        case .title, .headline, .headlineBold, .body, .tiny: return false
        case .link: return true
        }
    }
}
