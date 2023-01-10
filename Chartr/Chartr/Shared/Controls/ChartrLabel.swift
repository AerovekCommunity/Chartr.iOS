//
//  ChartrLabel.swift
//  Chartr
//
//  Created by Jay Martinez on 6/10/22.
//

import UIKit

@IBDesignable
class ChartrLabel: UILabel {
    
    // MARK: Properties
    
    var style: TextStyle? { didSet { updateStyle() } }
    var color: AppColor? { didSet { updateStyle() } }
    
    
    // MARK: IBInspectable
    
    @IBInspectable
    var chartrColorIB: String? {
        willSet {
            if let newColor = AppColor(rawValue: newValue ?? "") {
                color = newColor
            }
        }
        
        didSet {
            self.textColor = color?.color ?? .black
        }
    }
    
    @IBInspectable
    var styleIB: String? {
        willSet {
            if let newStyle = TextStyle(rawValue: newValue ?? "") {
                style = newStyle
            }
        }
    }
    
    // MARK: Private
    
    private func updateStyle() {
        guard let text = text else { return }
        
        attributedText = NSAttributedString
            .string(from: text, style: style ?? .title, color: color?.color ?? .black, alignment: textAlignment)
    }
}
