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

@IBDesignable
class CardView: UIView {
    var style: CardViewStyle = .buttonView {
        didSet {
            applyStyle()
        }
    }
    
    @IBInspectable
    var styleIB: String? {
        didSet {
            if let newStyle = CardViewStyle(rawValue: styleIB ?? "") {
                style = newStyle
            } else {
                print("ERROR trying to apply unknown style \(styleIB ?? "") to \(self)")
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        if let height = style.intrinsicHeight {
            return CGSize(width: super.intrinsicContentSize.width, height: height)
        } else {
            return super.intrinsicContentSize
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        applyStyle()
    }
    
    private func applyStyle() {
        self.isUserInteractionEnabled = true
        self.backgroundColor = self.style.backgroundColor
        self.layer.cornerRadius = self.style.cornerRadius
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = self.style.shadowOffset
        self.layer.shadowRadius = self.style.shadowRadius
        self.layer.shadowOpacity = self.style.shadowOpacity
    }
}
