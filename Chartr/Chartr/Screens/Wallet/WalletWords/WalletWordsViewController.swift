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
import WalletCore

class WalletWordsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHtCnsrt: NSLayoutConstraint!
    @IBOutlet weak var hideWordsBtn: ChartrButton!
    @IBOutlet weak var eyeImage: UIImageView!
    
    private let cellSpacing: CGFloat = 16.0
    private let keychain = KeychainSwift()
    private var walletWordsDict: Dictionary<Int, String> = [:]
    
    override func viewWillAppear(_ animated: Bool) {
        // Navigating back from verify words we need to hide it again
        let navController = self.navigationController as? ChartrNavigationController
        navController?.updateNavigationBar()
    }
    
    
    override func viewDidLoad() {
        // Create the wallet
        let wallet = ErdSdk.shared.createNewWallet()
        
        // Store the words and private key in the keychain for more secure storage
        keychain.set(wallet.mnemonic, forKey: KeychainKeys.walletWords)
        keychain.set(wallet.getKeyForCoin(coin: .elrond).data, forKey: KeychainKeys.walletPrivateKey)
        
        // Public address is not sensitive data so just store it in user defaults
        UserDefaults.standard.set(wallet.getAddressForCoin(coin: .elrond), forKey: UserDefaultsKeys.walletAddress)
        
        collectionView.backgroundColor = AppColor.disabledGrey.color
        collectionView.layer.cornerRadius = 8
        
        let words = wallet.mnemonic
        var idx = 0
        words.split(separator: " ").forEach {
            walletWordsDict[idx] = String($0)
            idx += 1
        }
            
        print("WORD ITEMS: ----------> \(walletWordsDict.sorted { $0.0 < $1.0 })")
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        
        let verifyWordsVC: VerifyWordsViewController = UIStoryboard(name: "WalletWords", bundle: nil)
            .instantiateViewController(withIdentifier: "VerifyWords") as! VerifyWordsViewController
        
        let random1 = Int.random(in: 0..<8)
        let random2 = Int.random(in: 8..<16)
        let random3 = Int.random(in: 16..<24)
        
        guard random1 < 24 && random2 < 24 && random3 < 24 else { return }
        
        print("!!!!!!! RANDOM #1: \(random1 + 1)")
        print("!!!!!!! RANDOM #2: \(random2 + 1)")
        print("!!!!!!! RANDOM #3: \(random3 + 1)")
        
        verifyWordsVC.setRandomWords(first: random1, second: random2, third: random3, walletWordsDict)
        self.navigationController?.pushViewController(verifyWordsVC, animated: true)
    }
    
    @IBAction func hideWordsTapped(_ sender: Any) {
        if collectionView.isHidden {
            collectionView.isHidden = false
            eyeImage.isHidden = true
            hideWordsBtn.setTitle("Hide Words", for: .normal)
        } else {
            collectionView.isHidden = true
            eyeImage.isHidden = false
            hideWordsBtn.setTitle("Show Words", for: .normal)
        }
    }
}

extension WalletWordsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16.0, left: 16.0, bottom: 0.0, right: 16.0)
    }
}

extension WalletWordsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return walletWordsDict.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalletWordCell", for: indexPath) as! WalletWordCell
        cell.layer.cornerRadius = 8
        cell.backgroundColor = AppColor.white.color
        cell.layer.borderColor = AppColor.black.color.cgColor
        cell.layer.borderWidth = 0.5
        
        if let word = walletWordsDict[indexPath.row] {
            cell.label.text = "\(indexPath.row + 1) \(word)"
        } else {
            fatalError("ERROR - could not find word! WTF!")
        }
        
        return cell
    }
}

extension WalletWordsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
}

extension WalletWordsViewController: NavigableViewController {
    var navBarStyle: NavigationBarStyle {
        return .hidden
    }
}
