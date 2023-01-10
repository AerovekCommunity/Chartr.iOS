//
//  File.swift
//  Chartr
//
//  Created by Jay Martinez on 6/9/22.
//

import UIKit
import UniformTypeIdentifiers

@IBDesignable
class ChartrButton: UIButton {
    var buttonStyle: ButtonStyle = .primary {
        didSet {
            applyStyle()
        }
    }
    
    @IBInspectable var buttonStyleIB: String? {
        didSet {
            if let newStyle = ButtonStyle(rawValue: buttonStyleIB ?? "") {
                buttonStyle = newStyle
            } else {
                print("ERROR trying to apply unknown style \(buttonStyleIB ?? "n/a") to \(self)")
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        if let height = buttonStyle.intrinsicHeight {
            return CGSize(width: super.intrinsicContentSize.width, height: height)
        } else {
            return super.intrinsicContentSize
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        applyStyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyStyle()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        refreshTitle()
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        refreshTitle()
    }
    
    private func applyStyle() {
        backgroundColor = isEnabled ? buttonStyle.backgroundColor : buttonStyle.backgroundColorDisabled
        
        if let borderColor = buttonStyle.borderColor {
            layer.borderColor = borderColor
            layer.borderWidth = buttonStyle.borderWidth
        }
        
        if let cornerRadius = buttonStyle.cornerRadius(in: self.frame) {
            layer.cornerRadius = cornerRadius
        }
        
        if !self.constraints.isEmpty {
            if let heightConstraint = self.constraints.first(where: { $0.firstAttribute == .height }), let buttonHeight = buttonStyle.intrinsicHeight {
                heightConstraint.constant = buttonHeight
            }
            if let widthConstraint = self.constraints.first(where: { $0.firstAttribute == .width }), let buttonWidth = buttonStyle.buttonWidth {
                widthConstraint.constant = buttonWidth
            }
        }
        
        refreshTitle()
    }
    
    private func refreshTitle() {
        let state = UIControl.State.normal
        if let text = title(for: state), let textStyle = buttonStyle.textStyle {
            let textColor = buttonStyle.textColor
            let attributedTitle = NSAttributedString.string(from: text, style: textStyle, color: textColor, alignment: .center, underlinedPortion: nil)
            setAttributedTitle(attributedTitle, for: state)
        }
    }
}
