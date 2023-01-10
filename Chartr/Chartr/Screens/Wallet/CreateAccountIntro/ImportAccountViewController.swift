//
//  ImportAccountViewController.swift
//  Chartr
//
//  Created by Jay Martinez on 6/24/22.
//

import UIKit
import WalletCore
import KeychainSwift

class ImportAccountViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var continueButton: ChartrButton!
    
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        self.hideKeyboardOnViewTap()
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        let words = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let wordsArray = words.split(separator: " ")
        guard wordsArray.count == 24 else {
            showAlert("Invalid", "Please check you entered the correct words. Expected 24 words but found \(wordsArray.count).", "Ok") { _ in
                print("No-op")
            }
            return
        }
        
        print("ENTERED WORDS: \(words)")
        
        continueButton.showActivityIndicator()
        
        let wallet = HDWallet(mnemonic: words, passphrase: "")
        let address = wallet.getAddressForCoin(coin: .elrond)
        print("ADDRESS: \(address)")
        
        ErdSdk.shared.elrondService.getAccount(bech32: address)
            .onSuccess { account in
                let privateKey = wallet.getKeyForCoin(coin: .elrond)
                self.keychain.set(wallet.mnemonic, forKey: KeychainKeys.walletWords)
                self.keychain.set(privateKey.data, forKey: KeychainKeys.walletPrivateKey)
                UserDefaults.standard.set(address, forKey: UserDefaultsKeys.walletAddress)
                
                // Finally copy the temp pin to the real pin. The temp pin was there in case
                // the user force quits the app before completely finishing account setup
                guard let tempPin = UserDefaults.standard.string(forKey: UserDefaultsKeys.userPinTemporary) else { fatalError("No temporary PIN was found, need to find out why!!") }
                
                UserDefaults.standard.set(tempPin, forKey: UserDefaultsKeys.userPin)
                
                // Now clear the temp pin
                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userPinTemporary)
                
                // At this point the home VC should be the root
                self.navigationController?.popToRootViewController(animated: true)
            }
            .onFailure { err in
                print("ERROR RETRIEVING ACCOUNT: \(err.description) -- \(err.failureResponse?.code ?? 0)")
            }
        
    }
}
