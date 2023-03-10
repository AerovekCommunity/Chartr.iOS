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
import BigInt

class UserWalletViewController: UIViewController {
    
    @IBOutlet weak var egldBalanceLabel: ChartrLabel!
    @IBOutlet weak var balanceLabel: ChartrLabel!
    private let keychain = KeychainSwift()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBalance()
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        getBalance()
    }
    
    @objc
    private func getBalance() {
        if let walletAddress = UserDefaults.standard.string(forKey: UserDefaultsKeys.walletAddress),
           let walletWords = keychain.get(KeychainKeys.walletWords) {
            print("WALLET ADDRESS: \(walletAddress)")
            
            #if DEBUG
            print("Wallet words: \(walletWords)")
            #endif
            
            ErdSdk.shared.elrondService.getAccount(bech32: walletAddress)
                .onSuccess { account in
                    let balance = try? account.data.account.balance.toBigInt()
                    print("SETTING EGLD BALANCE... \(account.data.account.balance)")
                    self.setBalance(label: self.egldBalanceLabel, balance: balance)
                }
                .onFailure { err in
                    fatalError("Failed to get account information! - \(err.localizedDescription)")
                }
            
            ErdSdk.shared.elrondService.getAeroTokenDetails(bech32: walletAddress)
                .onSuccess { token in
                    let balance = try? token.balance.toBigInt()
                    print("SETTING AERO BALANCE...")
                    self.setBalance(label: self.balanceLabel, balance: balance)
                }
                .onFailure { err in
                    // What's stupid is that if no AERO exists yet we get a 404 from the chain,
                    //  so if we get into this failure block it's likely due to that
                    print("Error retrieving aero balance: \(err.localizedDescription)")
                    self.balanceLabel.text = "0"
                }
        } else {
            fatalError("ERROR: Something is not right - no wallet words or address found in the keychain and there should be at this point")
        }
    }
    
    private func setBalance(label: ChartrLabel, balance: BigInt?) {
        if let balance = balance, balance > 0 {
            let divisionResult = balance.quotientAndRemainder(dividingBy: ErdSdk.divisor)
            print("BALANCE QUOTIENT: \(divisionResult.quotient)")
            print("BALANCE REMAINDER: \(divisionResult.remainder)")
            
            var remainderStr = String(divisionResult.remainder)
            if (remainderStr.count < 18) {
                for _ in remainderStr.count..<18 {
                    remainderStr = "0" + remainderStr
                    print("REMAINDER STRING = \(remainderStr)")
                }
            }
            
            label.text = "\(divisionResult.quotient).\(String(remainderStr.prefix(5)))"
        } else {
            label.text = "0"
        }
    }
}

extension UserWalletViewController: NavigableViewController {
    var navBarTitle: String? { "My Wallet" }
    
    var leftBarButtonItemStyle: BarButtonItemStyle { .back }
    var rightBarButtonItemStyle: BarButtonItemStyle { .refresh }
    
    var navBarStyle: NavigationBarStyle { .clear }
    
    func action(for item: BarButtonItemStyle) -> Selector? {
        switch item {
        case .back:
            return #selector(popController)
        case .refresh:
            return #selector(getBalance)
        default: return nil
        }
    }
}
