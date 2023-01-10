//
//  BarButtonItemStyle.swift
//  Chartr
//
//  Created by Jay Martinez on 6/7/22.
//

import UIKit

enum BarButtonItemStyle {
    case none
    case back
    case close
    case refresh
    
    func barButtonItem(action itemAction: Selector, target actionTarget: Any?) -> UIBarButtonItem? {
        var item: UIBarButtonItem
        
        switch self {
        case .none:
            return nil
        case .back:
            item = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: actionTarget, action: itemAction)
        case .close:
            item = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: actionTarget, action: itemAction)
        case .refresh:
            item = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: actionTarget, action: itemAction)
        }
        
        return item
    }
}
