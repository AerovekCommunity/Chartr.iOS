//
//  PinPadViewController.swift
//  Chartr
//
//  Created by Jay Martinez on 5/19/22.
//

import UIKit
import KeychainSwift

protocol PinPadDelegate {
    func entryComplete(pinValue: String)
}

class PinPadViewController: UIViewController, UITextInputTraits {
    
    @IBOutlet weak var pin1: UIView!
    @IBOutlet weak var pin2: UIView!
    @IBOutlet weak var pin3: UIView!
    @IBOutlet weak var pin4: UIView!
    @IBOutlet weak var pin5: UIView!
    @IBOutlet weak var pin6: UIView!
    @IBOutlet weak var enterPinLabel: ChartrLabel!
    
    private lazy var keychain = KeychainSwift()
    private var firstEntries: [String] = []
    private var secondEntries: [String] = []
    private var isFirstEntry = true
    private var regex: NSRegularExpression?
    private var isCreatingNewPin = true
    private var completionHandler: ((String, Bool) -> Void)?
    private let maxTries = 5
    private var numTries = 0
    
    var keyboardType: UIKeyboardType = .numberPad
    
    func initialize(isCreatingNewPin: Bool, completionHandler: @escaping (String, Bool) -> Void) {
        self.isCreatingNewPin = isCreatingNewPin
        self.completionHandler = completionHandler
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Simple regex to catch repeating digits or a few others like 123456
        regex = try? NSRegularExpression(pattern: "\\b(\\d)\\1+\\b|123456|234567|345678|456789")
        
        let radius = pin1.frame.width / 2
        pin1.layer.cornerRadius = radius
        pin2.layer.cornerRadius = radius
        pin3.layer.cornerRadius = radius
        pin4.layer.cornerRadius = radius
        pin5.layer.cornerRadius = radius
        pin6.layer.cornerRadius = radius
        
        self.becomeFirstResponder()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.resignFirstResponder()
    }
}

extension PinPadViewController: UIKeyInput {
    
    var hasText: Bool {
        return true
    }
    
    func insertText(_ text: String) {
        if isFirstEntry {
            firstEntries.append(text)
            updateDots(firstEntries)
            debugPrint("-----> CURRENT FIRST ENTRY PIN VALUE: \(firstEntries.joined())")
            
            if firstEntries.count == 6 {
                if !isCreatingNewPin {
                    guard let userPin = UserDefaults.standard.string(forKey: UserDefaultsKeys.userPin) else { fatalError("User PIN not found in user defaults!!") }
                        
                    if firstEntries.joined() != userPin {
                        showAlert(LocalizedStrings.Alert.invalidPinTitle, LocalizedStrings.Alert.invalidPin, "Ok") { _ in
                            print("NO-OP")
                        }
                        firstEntries.removeAll()
                        updateDots(self.firstEntries)
                    } else {
                        if let completion = completionHandler {
                            completion(firstEntries.joined(), true)
                            return
                        }
                    }
                    
                } else {
                    if !validateEntry() {
                        debugPrint("----- INSECURE PATTERN DETECTED, ENTER A MORE SECURE PIN!")
                        showAlert(LocalizedStrings.Alert.insecurePinTitle, LocalizedStrings.Alert.insecurePinMessage, "Ok") { _ in
                            print("NO-OP")
                        }
                        firstEntries.removeAll()
                        updateDots(self.firstEntries)
                        return
                    }
                    
                    enterPinLabel.text = LocalizedStrings.Labels.confirmPin
                    isFirstEntry = false
                }
            }
        } else {
            secondEntries.append(text)
            updateDots(secondEntries)
            if secondEntries.count == 6 {
                if secondEntries.joined() == firstEntries.joined() {
                    if let completion = completionHandler {
                        completion(secondEntries.joined(), true)
                        return
                    }
                } else {
                    debugPrint("----- PINS DON'T MATCH, TRY AGAIN")
                    secondEntries.removeAll()
                    updateDots(secondEntries)
                }
            }
        }
    }
    
    func deleteBackward() {
        debugPrint("-----> Back key pressed")
        if isFirstEntry {
            guard firstEntries.count > 0 else { return }
            firstEntries.remove(at: firstEntries.count - 1)
            updateDots(firstEntries)
            debugPrint("-----> CURRENT FIRST ENTRY PIN VALUE: \(firstEntries.joined())")
        } else {
            guard secondEntries.count > 0 else { return }
            secondEntries.remove(at: secondEntries.count - 1)
            updateDots(secondEntries)
            debugPrint("-----> CURRENT SECOND ENTRY PIN VALUE: \(secondEntries.joined())")
        }
        
    }
    
    /// Validates the first entry for a secure pattern
    private func validateEntry() -> Bool {
        let pinString = firstEntries.joined()
        let range = NSRange(location: 0, length: pinString.count)
        return regex?.firstMatch(in: pinString, range: range) == nil
    }
    
    private func updateDots(_ entries: [String]) {
        switch entries.count {
        case 0:
            pin1.backgroundColor = AppColor.disabledGrey.color
            pin2.backgroundColor = AppColor.disabledGrey.color
            pin3.backgroundColor = AppColor.disabledGrey.color
            pin4.backgroundColor = AppColor.disabledGrey.color
            pin5.backgroundColor = AppColor.disabledGrey.color
            pin6.backgroundColor = AppColor.disabledGrey.color
        case 1:
            pin1.backgroundColor = AppColor.aeroBlue.color
            pin2.backgroundColor = AppColor.disabledGrey.color
            pin3.backgroundColor = AppColor.disabledGrey.color
            pin4.backgroundColor = AppColor.disabledGrey.color
            pin5.backgroundColor = AppColor.disabledGrey.color
            pin6.backgroundColor = AppColor.disabledGrey.color
        case 2:
            pin2.backgroundColor = AppColor.aeroBlue.color
            pin3.backgroundColor = AppColor.disabledGrey.color
            pin4.backgroundColor = AppColor.disabledGrey.color
            pin5.backgroundColor = AppColor.disabledGrey.color
            pin6.backgroundColor = AppColor.disabledGrey.color
        case 3:
            pin3.backgroundColor = AppColor.aeroBlue.color
            pin4.backgroundColor = AppColor.disabledGrey.color
            pin5.backgroundColor = AppColor.disabledGrey.color
            pin6.backgroundColor = AppColor.disabledGrey.color
        case 4:
            pin4.backgroundColor = AppColor.aeroBlue.color
            pin5.backgroundColor = AppColor.disabledGrey.color
            pin6.backgroundColor = AppColor.disabledGrey.color
        case 5:
            pin5.backgroundColor = AppColor.aeroBlue.color
            pin6.backgroundColor = AppColor.disabledGrey.color
        case 6:
            pin6.backgroundColor = AppColor.aeroBlue.color
        default: return
        }
    }
    
}

