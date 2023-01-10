//
//  SendAeroViewController.swift
//  Chartr
//
//  Created by Jay Martinez on 6/21/22.
//

import UIKit
import BigInt
import WalletCore
import SwiftProtobuf
import KeychainSwift
import AVFoundation

class SendAeroViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var amountTextView: UITextField!
    @IBOutlet weak var continueButton: ChartrButton!
    @IBOutlet weak var sendToAddressTextField: UITextField!
    @IBOutlet weak var qrcodeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTextView.delegate = self
        sendToAddressTextField.delegate = self
        amountTextView.layer.borderWidth = 2
        amountTextView.layer.borderColor = AppColor.disabledGrey.color.cgColor
        sendToAddressTextField.layer.borderWidth = 2
        sendToAddressTextField.layer.borderColor = AppColor.disabledGrey.color.cgColor
        
        var segmentTextAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: TextStyle.body.font]
        segmentTextAttributes[NSAttributedString.Key.foregroundColor] = AppColor.white.color
        segmentedControl.setTitleTextAttributes(segmentTextAttributes, for: .normal)
        
        hideKeyboardOnViewTap()
        
        qrcodeImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(qrcodeTapped)))
    }
    
    @objc
    func qrcodeTapped(_ sender: AnyObject) {
        let scannerView = ScannerViewController()
        scannerView.scannerDelgate = self
        self.navigationController?.present(scannerView, animated: true)
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        if let _ = try? amountTextView.text?.toDouble(),
           let amountDisplay = amountTextView.text,
           let toAddress = sendToAddressTextField.text,
           let address = UserDefaults.standard.string(forKey: UserDefaultsKeys.walletAddress) {
            continueButton.showActivityIndicator()
            
            self.validateAddress(address: toAddress) { isValid in
                if (isValid) {
                    ErdSdk.shared.elrondService.getNetworkConfig()
                        .onSuccess { config in
                            
                            ErdSdk.shared.elrondService.getAccount(bech32: address)
                                .onSuccess { account in
                                    let minGasLimit: BigInt = 500000
                                    let minGasPrice = config.data.config.minGasPrice == 0
                                        ? 1000000000 : config.data.config.minGasPrice
                                    let transactionVersion = config.data.config.minTransactionVersion
                                    let chainId = config.data.config.chainId
                                    let nonce = account.data.account.nonce
                                    
                                    // Split it into a 2 element array
                                    // [0] = whole number part
                                    // [1] = decimal part
                                    let amountParts = amountDisplay.split(separator: ".")
                                    let amountString = ErdSdk.shared.getErdAmountString(from: amountParts)
                                    
                                    guard let amountBig = try? amountString.toBigInt() else {
                                        fatalError("Failed to convert the final amount string to a BigInt")
                                    }
                                    
                                    // Check EGLD balance to cover gas fees
                                    if let egldBalance = try? account.data.account.balance.toBigInt(),
                                        egldBalance > minGasLimit {
                                        
                                        guard let verifySendVC: VerifySendViewController = UIStoryboard(name: "UserWallet", bundle: nil)
                                            .instantiateViewController(withIdentifier: "VerifySend") as? VerifySendViewController else { fatalError("Unable to instantiate VerifySendViewController") }
                                        
                                        let keychain = KeychainSwift()
                                        
                                        guard let privateKey = keychain.getData(KeychainKeys.walletPrivateKey) else { fatalError("Could not find private key in keychain storage") }
                                        
                                        #if DEBUG
                                        print("PRIVATE KEY: \(privateKey)")
                                        #endif
                                        
                                        var signerInput = ElrondSigningInput.with {
                                            $0.privateKey = privateKey
                                            $0.transaction = ElrondTransactionMessage.with {
                                                $0.nonce = UInt64(nonce)
                                                $0.receiver = toAddress
                                                $0.sender = address
                                                $0.gasPrice = UInt64(minGasPrice)
                                                $0.gasLimit = UInt64(minGasLimit)
                                                $0.chainID = chainId
                                                $0.version = UInt32(transactionVersion)
                                            }
                                        }
                                        
                                        switch (self.segmentedControl.selectedSegmentIndex) {
                                        case 0:
                                            ErdSdk.shared.elrondService.getAeroTokenDetails(bech32: address)
                                                .onSuccess { token in
                                                    if let balance = try? token.balance.toBigInt(),
                                                       balance >= amountBig {
                                                        // This is a ESDT transfer so we need to call a special function
                                                        //  and requires the Value field to be set to 0 (below)
                                                        // The token and value need to be hex encoded
                                                        var valueHex = String(amountBig, radix: 16)
                                                        
                                                        // If valueHex is odd we need to pad a leading zero
                                                        if valueHex.count % 2 != 0 {
                                                            valueHex = "0" + valueHex
                                                        }
                                                        
                                                        let tokenIdData = ErdSdk.shared.elrondService.aeroTokenId.data(using: .utf8)?.hexString
                                                        
                                                        print("VALUE HEX: \(valueHex)")
                                                        print("TOKEN ID HEX: \(tokenIdData ?? "n/a")")
                                                        
                                                        if let tokenIdHex = tokenIdData {
                                                            let functionData = "ESDTTransfer@\(tokenIdHex)@\(valueHex)"
                                                            signerInput.transaction.data = functionData
                                                            signerInput.transaction.value = "0"
                                                            
                                                            print("TRANSACTION DATA: \(signerInput.transaction.data)")
                                                            
                                                            verifySendVC.initialize(
                                                                signerInput: signerInput,
                                                                amountDisplay: amountDisplay,
                                                                token: "AERO")
                                                            self.navigationController?.pushViewController(verifySendVC, animated: true)
                                                        }
                                                    } else {
                                                        self.showAlert("Insufficient Funds", "You don't have enough AERO to cover the amount you want to send.", "Ok") { _ in
                                                            print("no-op")
                                                        }
                                                    }
                                                    self.continueButton.hideActivityIndicator()
                                                }
                                                .onFailure { err in
                                                    // What's stupid is that if no AERO exists yet we get a 404 from the chain,
                                                    //  so if we get into this failure block it's likely due to that
                                                    print("Error retrieving aero balance: \(err.localizedDescription)")
                                                    self.showAlert("Insufficient Funds", "You don't have enough AERO to cover the amount you want to send.", "Ok") { _ in
                                                        self.continueButton.hideActivityIndicator()
                                                    }
                                                }
                                        case 1:
                                            if egldBalance >= amountBig - minGasLimit {
                                                signerInput.transaction.value = amountString
                                                verifySendVC.initialize(
                                                    signerInput: signerInput,
                                                    amountDisplay: amountDisplay,
                                                    token: "EGLD")
                                                self.continueButton.hideActivityIndicator()
                                                self.navigationController?.pushViewController(verifySendVC, animated: true)
                                            } else {
                                                self.showAlert("Insufficient Funds", "You don't have enough EGLD to cover the amount you want to send.", "Ok") { _ in
                                                    self.continueButton.hideActivityIndicator()
                                                }
                                            }
                                        default: break
                                        }
                                        
                                    } else {
                                        self.showAlert("Insufficient Gas", "You need more EGLD to cover the gas fee for this transaction", "Ok") { _ in
                                            self.continueButton.hideActivityIndicator()
                                        }
                                    }
                                }
                                .onFailure { err in
                                    fatalError("Failed to get account information!")
                                }
                        }
                        .onFailure { err in
                            self.showAlert("Network Error", "Please try again later.", "Ok") { _ in
                                self.continueButton.hideActivityIndicator()
                        }
                    }
                }
            }
            
        } else {
            print("Amount in the SEND textfield is not a valid floating point number")
        }
    }
    
    private func validateAddress(address: String, callback: @escaping (Bool) -> Void) {
        ErdSdk.shared.validateAddress(address: address) { validatedAddress in
            if let addr = validatedAddress {
                self.sendToAddressTextField.text = addr
                self.continueButton.isEnabled = true
                self.continueButton.hideActivityIndicator(isEnabled: true)
                self.continueButton.buttonStyle = .primary
                callback(true)
            } else {
                self.showAlert(LocalizedStrings.Alert.invalidAddressTitle, LocalizedStrings.Alert.invalidAddressMessage, "Ok") { _ in
                    self.sendToAddressTextField.text = ""
                    self.continueButton.isEnabled = false
                    self.continueButton.hideActivityIndicator(isEnabled: false)
                    self.continueButton.buttonStyle = .primary
                    callback(false)
                }
            }
        }
    }
}

extension SendAeroViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let text = textField.text, !text.isEmpty else {
            continueButton.isEnabled = false
            continueButton.buttonStyle = .primary
            return
        }
        
        var isEnabled = false
        switch (textField.tag) {
        case 0: // amount textfield
            do {
                let value = try text.toDouble()
                print("DOUBLE VALUE: \(value)")
                if let sendToAddress = sendToAddressTextField.text, !sendToAddress.isEmpty, value > 0 {
                    isEnabled = true
                } else {
                    isEnabled = false
                }
                amountTextView.text = String(value)
            } catch {
                isEnabled = false
            }
                
        case 1: // to address textfield
            if let amountText = amountTextView.text, !amountText.isEmpty {
                isEnabled = true
            } else {
                isEnabled = false
            }
        default: break
        }
        
        continueButton.isEnabled = isEnabled
        
        // For now this is how we refresh the button style to reflect the isEnabled state
        continueButton.buttonStyle = .primary
    }
}

extension SendAeroViewController: ScannerDelegate {
    func postAddress(address: String) {
        print("!!! ADDRESS POSTED BY SCANNER: \(address)")
        self.navigationController?.dismiss(animated: true)
        self.continueButton.showActivityIndicator()
        self.validateAddress(address: address) { _ in
            print("Address is valid")
        }
    }
}

extension SendAeroViewController: NavigableViewController {
    var navBarStyle: NavigationBarStyle { return .clear }
    var leftBarButtonItemStyle: BarButtonItemStyle { return .close }
    var navBarTitle: String? { return "Send" }
}

extension Int64 {
    func toBigInt() throws -> BigInt {
        if self < 0 { throw CastingError.int64ToBigInt }
        return BigInt(self)
    }
}
