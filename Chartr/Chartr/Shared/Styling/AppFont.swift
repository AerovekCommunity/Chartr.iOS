//
//  AppFont.swift
//  Chartr
//
//  Created by Jay Martinez on 6/9/22.
//

import CoreGraphics
import UIKit

enum AppFont {
    case primaryThin
    case primaryNormal
    case primaryHeavy
    
    func font(of size: CGFloat) -> UIFont {
        var fontName = "Invalid"
        switch self {
        case .primaryThin: fontName = "MuseoSans-300"
        case .primaryNormal: fontName = "MuseoSans-500"
        case .primaryHeavy: fontName = "MuseoSans-700"
        }
        
        return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
