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
import KeychainSwift

class ProtectWalletViewController: UIViewController {
    @IBOutlet weak var continueButton: ChartrButton!
    
    @IBOutlet weak var pinStatusLabel: ChartrLabel!
    @IBOutlet weak var biometricsStatusLabel: ChartrLabel!
    
    @IBOutlet weak var enableBiometricsView: CardView!
    @IBOutlet weak var createPasscodeView: CardView!
    
    private var createPinTapGesture: UIGestureRecognizer!
    private var isNewWallet = true
    
    func initialize(isNewWallet: Bool) {
        self.isNewWallet = isNewWallet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPinTapGesture = UITapGestureRecognizer()
        createPinTapGesture.addTarget(self, action: #selector(createPinTapped(sender:)))
        createPasscodeView.addGestureRecognizer(createPinTapGesture)
    }
    
    @objc
    func createPinTapped(sender: UITapGestureRecognizer) {
        guard let pinPadViewController: PinPadViewController = UIStoryboard(name: "PinPad", bundle: nil)
            .instantiateViewController(withIdentifier: "PinPad") as? PinPadViewController else { fatalError("Unable to instantiate PinPadViewController") }
        
        pinPadViewController.initialize(isCreatingNewPin: true) { (pin, isSuccessful) in
            if isSuccessful {
                self.navigationController?.dismiss(animated: true)
                self.pinStatusLabel.text = LocalizedStrings.Labels.complete
                self.pinStatusLabel.textColor = AppColor.green.color
                self.createPasscodeView.removeGestureRecognizer(self.createPinTapGesture)
                self.createPasscodeView.isUserInteractionEnabled = false
                
                // Successful pin creation so now set tap handler for enabling biometrics
                // TODO - enable this once the biometric logic is in place
                //enableBiometricsView.isHidden = false
                let gesture = UITapGestureRecognizer()
                gesture.addTarget(self, action: #selector(self.enableBiometrics(sender:)))
                self.enableBiometricsView.addGestureRecognizer(gesture)
                
                self.continueButton.isHidden = false
                
                // Store the PIN temporarily, this will be copied over to the keychain
                // after they finish the setup process.
                UserDefaults.standard.set(pin, forKey: UserDefaultsKeys.userPinTemporary)
            } else {
                print("Some error occurred trying to create the PIN, needs investigating!")
            }
        }
        
        self.navigationController?.present(pinPadViewController, animated: true)
    }
    
    @objc
    func enableBiometrics(sender: UITapGestureRecognizer) {
        
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        if self.isNewWallet {
            guard let walletTipsVC: ProtectWalletTipsViewController = UIStoryboard(name: "ProtectWalletTips", bundle: nil)
                .instantiateViewController(withIdentifier: "ProtectWalletTips") as? ProtectWalletTipsViewController else { fatalError("Unable to instantiate ProtectWalletTipsViewController") }
            
            self.navigationController?.pushViewController(walletTipsVC, animated: true)
        } else {
            guard let importAccountVC: ImportAccountViewController = UIStoryboard(name: "CreateAccount", bundle: nil)
                .instantiateViewController(withIdentifier: "ImportAccount") as? ImportAccountViewController else { fatalError("Unable to instantiate ImportAccountViewController") }
            self.navigationController?.pushViewController(importAccountVC, animated: true)
        }
    }
}

extension ProtectWalletViewController: NavigableViewController {
    var navBarStyle: NavigationBarStyle { return .clear }
}
