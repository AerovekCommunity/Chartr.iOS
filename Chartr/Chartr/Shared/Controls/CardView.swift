//
//  CardView.swift
//  Chartr
//
//  Created by Jay Martinez on 6/15/22.
//

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
