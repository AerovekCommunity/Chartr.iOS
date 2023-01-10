//
//  KeepPhraseSafeViewController.swift
//  Chartr
//
//  Created by Jay Martinez on 6/16/22.
//

import UIKit
import WalletCore
import KeychainSwift

class KeepPhraseSafeViewController: UIViewController {
    @IBOutlet weak var continueButton: ChartrButton!
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        let walletWordsVC = UIStoryboard(name: "WalletWords", bundle: nil)
            .instantiateViewController(withIdentifier: "WalletWords")
        
        self.navigationController?.pushViewController(walletWordsVC, animated: true)
    }
}
