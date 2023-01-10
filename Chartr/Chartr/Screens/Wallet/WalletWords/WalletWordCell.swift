//
//  WalletWordCell.swift
//  Chartr
//
//  Created by Jay Martinez on 6/18/22.
//

import UIKit

class WalletWordCell: UICollectionViewCell {
    @IBOutlet weak var label: ChartrLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open func handleTapGesture(_ gesture: UIGestureRecognizer) {
        // should be overriden
    }
}
