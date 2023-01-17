/*
The MIT License (MIT)

Copyright (c) 2023-present Aerovek

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

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
