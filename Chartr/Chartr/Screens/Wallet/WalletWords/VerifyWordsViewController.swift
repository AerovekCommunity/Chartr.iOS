//
//  VerifyWordsViewController.swift
//  Chartr
//
//  Created by Jay Martinez on 6/18/22.
//

import UIKit
import KeychainSwift

class VerifyWordsViewController: UIViewController {
    @IBOutlet weak var word1Label: ChartrLabel!
    @IBOutlet weak var word1TextView: UITextField!
    
    @IBOutlet weak var viewInExplorerBtn: ChartrButton!
    @IBOutlet weak var continueBtn: ChartrButton!
    @IBOutlet weak var word2Label: ChartrLabel!
    @IBOutlet weak var word2TextView: UITextField!
    
    @IBOutlet weak var word3Label: ChartrLabel!
    @IBOutlet weak var word3TextView: UITextField!
    
    private var firstRando: Int = -1
    private var secondRando: Int = -1
    private var thirdRando: Int = -1
    private var words: Dictionary<Int, String>!
    
    func setRandomWords(first: Int, second: Int, third: Int, _ actualWords: Dictionary<Int, String>) {
        firstRando = first
        secondRando = second
        thirdRando = third
        words = actualWords
    }
    
    override func viewDidLoad() {
        word1TextView.layer.borderWidth = 1
        word1TextView.layer.borderColor = AppColor.black.color.cgColor
        
        word2TextView.layer.borderWidth = 1
        word2TextView.layer.borderColor = AppColor.black.color.cgColor
        
        word3TextView.layer.borderWidth = 1
        word3TextView.layer.borderColor = AppColor.black.color.cgColor
        
        word1Label.text = "Enter word #\(firstRando + 1)"
        word2Label.text = "Enter word #\(secondRando + 1)"
        word3Label.text = "Enter word #\(thirdRando + 1)"
        
        self.hideKeyboardOnViewTap()
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        let word1Value = word1TextView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let word2Value = word2TextView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let word3Value = word3TextView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let word1Expected = words[firstRando]
        let word2Expected = words[secondRando]
        let word3Expected = words[thirdRando]
        
        if word1Value != word1Expected || word2Value != word2Expected || word3Value != word3Expected {
            showAlert("Try Again", "You entered the wrong value in one of the fields", "Ok") { _ in
                print("Wrong field entered and ok tapped")
            }
        } else {
            print("WALLET ADDRESS: \(UserDefaults.standard.string(forKey: UserDefaultsKeys.walletAddress) ?? "NO WALLET FOUND!!!!!")")
            
            // Finally copy the temp pin to the real pin. The temp pin was there in case
            // the user force quits the app before completely finishing account setup
            guard let tempPin = UserDefaults.standard.string(forKey: UserDefaultsKeys.userPinTemporary) else { fatalError("No temporary PIN was found, need to find out why!!") }
            
            UserDefaults.standard.set(tempPin, forKey: UserDefaultsKeys.userPin)
            
            // Now clear the temp pin
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userPinTemporary)
            
            // At this point the home VC should be the root
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}

extension VerifyWordsViewController: NavigableViewController {
    var navBarStyle: NavigationBarStyle { return .clear }
}
