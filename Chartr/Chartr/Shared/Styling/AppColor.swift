//
//  Colors.swift
//  Chartr
//
//  Created by Jay Martinez on 6/7/22.
//

import UIKit

enum AppColor: String {
    case black
    case textRegular
    case textLight
    case disabledGrey
    case aeroBlue
    case backgroundGrey
    case backgroundDarkGrey
    case white
    case warning
    case green
    case yellow
    
    var color: UIColor {
        switch self {
        case .black: return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case .backgroundGrey: return #colorLiteral(red: 0.9764705882, green: 0.9725490196, blue: 0.968627451, alpha: 1)
        case .backgroundDarkGrey: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        case .aeroBlue: return #colorLiteral(red: 0.0431372549, green: 0.4274509804, blue: 1, alpha: 1)
        case .disabledGrey: return #colorLiteral(red: 0.7820063233, green: 0.7722578049, blue: 0.7723029256, alpha: 1)
        case .textLight: return #colorLiteral(red: 0.9411764706, green: 0.9333333333, blue: 0.9215686275, alpha: 1)
        case .textRegular: return #colorLiteral(red: 0.4156862745, green: 0.4156862745, blue: 0.4156862745, alpha: 1)
        case .white: return .white
        case .warning: return #colorLiteral(red: 0.9529411793, green: 0.4685409219, blue: 0, alpha: 1)
        case .yellow: return #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        case .green: return #colorLiteral(red: 0, green: 0.5853648929, blue: 0.06956988043, alpha: 1)
        }
    }
}
