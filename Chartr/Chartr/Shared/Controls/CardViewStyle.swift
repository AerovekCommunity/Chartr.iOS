//
//  CardViewStyle.swift
//  Chartr
//
//  Created by Jay Martinez on 6/15/22.
//

import CoreGraphics
import UIKit

enum CardViewStyle: String {
    case buttonView
    
    var intrinsicHeight: CGFloat? {
        switch self {
        case .buttonView: return ControlSizing.cardviewButtonViewTypeHeight.value
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .buttonView: return AppColor.white.color
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .buttonView: return ControlSizing.cornerRadiusStandard.value
        }
    }
    
    var shadowRadius: CGFloat {
        switch self {
        case .buttonView: return 4
        }
    }
    
    var shadowOffset: CGSize {
        switch self {
        case .buttonView: return CGSize(width: 0, height: 2)
        }
    }
    
    var shadowOpacity: Float {
        switch self {
        case .buttonView: return 0.3
        }
    }
}
