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

extension NSAttributedString {

    static func string(from string: String, style: TextStyle, color: UIColor?, alignment: NSTextAlignment = .center, underlinedPortion: String? = nil) -> NSAttributedString {
        let attributes = NSAttributedString.attributeDictionaryForStyle(style, color: color, alignment: alignment, suppressUnderline: underlinedPortion != nil)
                
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)

        if let underlineText = underlinedPortion,
            let underlineRange = string.range(of: underlineText) {

            attributedString.addAttributes(NSAttributedString.attributeDictionaryForStyle(style, color: color, alignment: alignment), range: NSRange(underlineRange, in: string))
        }

        return attributedString
    }
    
    static func attributeDictionaryForStyle(_ textStyle: TextStyle, color: UIColor?, alignment: NSTextAlignment = .center, suppressUnderline: Bool = false) -> ([NSAttributedString.Key: Any]) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = CGFloat(1)
        paragraphStyle.alignment = alignment
        
        var attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: textStyle.font]
        
        if let color = color {
            attributes[NSAttributedString.Key.foregroundColor] = color
        }

        if !suppressUnderline && textStyle.underlined {
            attributes[NSAttributedString.Key.underlineStyle] = NSNumber(value: true)
            attributes[NSAttributedString.Key.underlineColor] = AppColor.aeroBlue.color
        }
        
        return attributes
    }
}
