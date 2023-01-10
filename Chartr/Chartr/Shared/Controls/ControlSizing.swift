//
//  ControlSizing.swift
//  Chartr
//
//  Created by Jay Martinez on 6/9/22.
//

import CoreGraphics

enum ControlSizing {
    case primaryButtonHeight
    case secondaryButtonHeight
    case roundButtonSmallHeight
    case roundButtonSmallWidth
    case linkButtonHeight
    case cornerRadiusStandard
    case cornerRadiusLarge
    case cardviewButtonViewTypeHeight
    
    var value: CGFloat {
        switch self {
        case .primaryButtonHeight, .secondaryButtonHeight: return 48
        case .roundButtonSmallHeight: return 64
        case .roundButtonSmallWidth: return 64
        case .linkButtonHeight: return 30
        case .cornerRadiusStandard: return 6
        case .cornerRadiusLarge: return 16
        case .cardviewButtonViewTypeHeight: return 80
        }
    }
}
