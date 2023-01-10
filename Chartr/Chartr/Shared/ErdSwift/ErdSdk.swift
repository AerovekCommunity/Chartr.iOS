//
//  ErdSdk.swift
//  Chartr
//
//  Created by Jay Martinez on 5/7/22.
//

import Foundation
import BigInt
import WalletCore

class ErdSdk {
    /// Divide this value by the AERO or EGLD balance to get the display value
    /// 1000000000000000000 = 1 EGLD/AERO
    static let divisor: BigInt = 1000000000000000000
    
    // Use a singleton for the top level ErdSdk object
    static var shared: ErdSdk!
    
    let elrondService: ElrondService
    
    init() {
        /* TODO uncomment before we go live
        #if DEBUG
        self.elrondService = ElrondService(url: URL(string: "https://devnet-gateway.elrond.com")!)
        #else
        self.elrondService = ElrondService(url: URL(string: "https://gateway.elrond.com")!)
        #endif
         */
        
        let devAeroId = "AERO-7e99d6"
        let devMarsId = "MARS-adff2c"
        let mainAeroId = "AERO-458bbf"
        let devApiEndpoint = "https://devnet-api.elrond.com"
        let mainnetApiEndpoint = "https://api.elrond.com"
        let devnetGateway = "https://devnet-gateway.elrond.com"
        let mainnetGateway = "https://gateway.elrond.com"
        
        self.elrondService = ElrondService(
            gatewayUrl: URL(string: devnetGateway)!,
            apiUrl: URL(string: devApiEndpoint)!,
            aeroTokenId: devMarsId)
    }
    
    // MARK: Public Methods
    
    /// This method will convert the human readable token amount (i.e. 2500.1234) to the 18 decimal precision amount
    /// by taking in the whole number and decimal values and generating a string with the correct amount of zeros
    /// needed to achieve the 18 decimal place precision.
    /// - Parameter amountParts: An array consisting of the whole number part and the decimal part
    /// - Returns The erd amount string
    func getErdAmountString(from amountParts: [String.SubSequence]) -> String {
        let wholeNumValue = String(amountParts[0])
        let decimalValue = String(amountParts[1])
        var amountString = wholeNumValue
        
        // If the fractional piece is not 18 digits pad zeros to it
        if decimalValue.count < 18 {
            // First append the initial fractional value
            amountString += decimalValue
            
            // Start padding zeros
            for _ in decimalValue.count..<18 {
                amountString += "0"
            }
            
        } else {
            // else just append the 18 digit fractional piece to the whole number piece
            amountString += String(decimalValue)
        }
        
        if amountString.count != amountParts[0].count + 18  {
            fatalError("The amount length should be \(amountString.count)")
        }
        
        // Correct the result from above if entering less than a whole number value
        // since there will be leading zeros
        amountString = self.trimLeadingZeros(from: amountString)
        
        guard let amountBig = try? amountString.toBigInt() else {
            fatalError("Failed to convert the final amount string to a BigInt")
        }
        
        if self.validateFinalAmount(amountBig: amountBig, decimalValue: decimalValue, wholeNumValue: wholeNumValue) {
            print("---- Passed Secondary Validation")
        } else {
            //fatalError("\n\tFinal amount did not pass validation for AMOUNT: \(amountString)")
            print("\n\tFinal amount did not pass validation for AMOUNT: \(amountString)")
        }
        
        return amountString
    }
    
    /// Validates the address passed in by attempting to retrieve the account associated with this address
    ///   if it fails then the address is invalid
    func validateAddress(address: String, callback: @escaping (String?) -> Void) {
        ErdSdk.shared.elrondService.getAccount(bech32: address)
            .onSuccess { account in
                callback(account.data.account.address)
            }
            .onFailure { _ in
                callback(nil)
            }
    }
    
    /// Creates a new wallet
    func createNewWallet() -> HDWallet {
        return HDWallet(strength: 256, passphrase: "")
    }
    
    /// Creates a new wallet using the passed in 24 word mnemonic
    func importWallet(with mnemonic: String) -> HDWallet {
        return HDWallet(mnemonic: mnemonic, passphrase: "")
    }
    
    
    // MARK: Private Methods
    
    /// Since we're dealing with money we should do another validation check against the final string value
    /// by converting back to a BigInt then dividing that by our divisor to
    /// hopefully arrive at what the user entered
    private func validateFinalAmount(amountBig: BigInt, decimalValue: String, wholeNumValue: String) -> Bool {
        let checkResult = amountBig.quotientAndRemainder(dividingBy: ErdSdk.divisor)
        print("CHECK QUOTIENT: \(checkResult.quotient)")
        print("CHECK REMAINDER: \(checkResult.remainder)")
        
        var didPass = false
        if let decimalBig = try? decimalValue.toBigInt(),
           let wholeNumBig = try? wholeNumValue.toBigInt() {
            
            if wholeNumBig == checkResult.quotient {
                didPass = true
            }
            if decimalBig > 0 && checkResult.remainder % decimalBig == 0 {
                didPass = true
            }
        }
        
        return didPass
    }
    
    /// Trims the leading zeros from the passed in string and returns the result
    private func trimLeadingZeros(from amount: String) -> String {
        var result = amount
        var startIdxForTrim = 0
        for ch in amount {
            if ch == "0" {
                startIdxForTrim += 1
                continue
            }
            break
        }
        
        if startIdxForTrim > 0 {
            let idx = amount.index(amount.startIndex, offsetBy: startIdxForTrim)
            result = String(amount.suffix(from: idx))
        }
        
        return result
    }
}
