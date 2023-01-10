//
//  ChartrTextView.swift
//  Chartr
//
//  Created by Jay Martinez on 6/10/22.
//

import UIKit

@IBDesignable
class ChartrTextView: UITextView {
    
    private var displayText = NSMutableAttributedString()
    
    var style: TextStyle?
    var color: AppColor?
    
    @IBInspectable
    var colorIB: String? {
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
        
        didSet {
            updateAttributedText()
        }
    }
    
    private func setupView() {
        contentInset = .zero
    }
    
    private func updateAttributedText() {
        displayText = NSMutableAttributedString(attributedString: NSAttributedString
            .string(from: text, style: style ?? .title, color: color?.color))
    }
}
