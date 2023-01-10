//
//  NSAttributedString+Extensions.swift
//  Chartr
//
//  Created by Jay Martinez on 6/9/22.
//

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
