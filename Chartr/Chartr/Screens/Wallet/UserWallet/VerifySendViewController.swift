//
//  VerifySendViewController.swift
//  Chartr
//
//  Created by Jay Martinez on 6/28/22.
//

import UIKit
import BigInt
import WalletCore

class VerifySendViewController: UIViewController {
    
    @IBOutlet weak var addressLabel: ChartrLabel!
    @IBOutlet weak var amountLabel: ChartrLabel!
    @IBOutlet weak var sendButton: ChartrButton!
    
    var signerInput: ElrondSigningInput!
    var amountDisplay: String!
    var token: String!
    
    func initialize(signerInput: ElrondSigningInput, amountDisplay: String, token: String) {
        self.signerInput = signerInput
        self.amountDisplay = amountDisplay
        self.token = token
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressLabel.text = signerInput.transaction.receiver
        amountLabel.text = "\(amountDisplay ?? "0") \(token ?? "")"
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        guard let pinPadViewController: PinPadViewController = UIStoryboard(name: "PinPad", bundle: nil)
            .instantiateViewController(withIdentifier: "PinPad") as? PinPadViewController else { fatalError("Unable to instantiate PinPadViewController") }
        
        pinPadViewController.initialize(isCreatingNewPin: false) { (pin, isSuccessful) in
            if isSuccessful {
                self.navigationController?.dismiss(animated: true)
                self.sendButton.showActivityIndicator()
                
                let output: ElrondSigningOutput = AnySigner.sign(input: self.signerInput, coin: .elrond)
                
                #if DEBUG
                let outputPayload = try? JSONDecoder().decode(Transaction.self, from: output.encoded.data(using: .utf8)!)
                print("SIGNER OUTPUT DECODED: \(outputPayload?.data ?? "n/a")")
                #endif
                
                ErdSdk.shared.elrondService.sendTransaction(transactionData: output.encoded.data(using: .utf8))
                    .onSuccess { transactionResponse in
                        print("TX HASH: \(transactionResponse.data.txHash)")
                        if transactionResponse.data.txHash.isEmpty {
                            self.showAlert("Transaction Failed", "An error occurred while trying to process the transaction, please contact support and supply sender and receiver addresses.", "Ok") { _ in
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                        } else {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                    .onFailure { error in
                        self.showAlert("Transaction Failed", "An network error occurred while trying to process the transaction, please try again.", "Ok") { _ in
                            self.sendButton.hideActivityIndicator()
                        }
                    }
                
                // Validate transaction by simulating it first
                /*
                ErdSdk.shared.elrondService.validateTransaction(transactionData: output.encoded.data(using: .utf8))
                    .onSuccess { result in
                        // TODO - not sure if both or just one need to succeed to simulate a successful tx
                        if result.data.result.receiverShard.status.lowercased() == "success"
                            || result.data.result.senderShard.status.lowercased() == "success" {
                            // Now send the real transaction
                            ErdSdk.shared.elrondService.sendTransaction(transactionData: output.encoded.data(using: .utf8))
                                .onSuccess { transactionResponse in
                                    print("TX HASH: \(transactionResponse.data.txHash)")
                                    if transactionResponse.data.txHash.isEmpty {
                                        self.showAlert("Transaction Failed", "An error occurred while trying to process the transaction, please contact support and supply sender and receiver addresses.", "Ok") { _ in
                                            self.navigationController?.popToRootViewController(animated: true)
                                        }
                                    } else {
                                        self.navigationController?.popToRootViewController(animated: true)
                                    }
                                }
                                .onFailure { error in
                                    self.showAlert("Transaction Failed", "An network error occurred while trying to process the transaction, please try again.", "Ok") { _ in
                                        self.sendButton.hideActivityIndicator()
                                    }
                                }
                        }
                    }
                    .onFailure { error in
                        self.showAlert("Transaction Failed", "Failed to validate transaction, please try again.", "Ok") { _ in
                            self.sendButton.hideActivityIndicator()
                        }
                    }
                 */
                
            } else {
                print("Some error occurred trying to create the PIN, needs investigating!")
                self.sendButton.hideActivityIndicator()
            }
        }
        
        self.navigationController?.present(pinPadViewController, animated: true)
    }
}
