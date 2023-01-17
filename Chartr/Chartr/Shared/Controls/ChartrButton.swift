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
