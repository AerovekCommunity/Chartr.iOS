//
//  TextStyle.swift
//  Chartr
//
//  Created by Jay Martinez on 6/9/22.
//

import UIKit

enum TextStyle: String {
    case headline
    case headlineBold
    case title
    case tiny
    case body
    case link
    
    var font: UIFont {
        switch self {
        case .title: return AppFont.primaryNormal.font(of: 18)
        case .link, .body: return AppFont.primaryNormal.font(of: 16)
        case .tiny: return AppFont.primaryThin.font(of: 14)
        case .headline: return AppFont.primaryNormal.font(of: 24)
        case .headlineBold: return AppFont.primaryHeavy.font(of: 24)
        }
    }
    
    var underlined: Bool {
        switch self {
        case .title, .headline, .headlineBold, .body, .tiny: return false
        case .link: return true
        }
    }
}
