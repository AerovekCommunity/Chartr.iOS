//
//  LocalizedStrings.swift
//  Chartr
//
//  Created by Jay Martinez on 5/20/22.
//

import Foundation

struct LocalizedStrings {
    struct Alert {
        static let genericError = NSLocalizedString("A problem occurred", comment: "Message for generic dialog error message")
        static let insecurePinTitle = NSLocalizedString("Insecure PIN", comment: "Insecure PIN title")
        static let insecurePinMessage = NSLocalizedString("Insecure PIN detected, please enter a more secure PIN", comment: "Insecure PIN message")
        static let invalidPinTitle = NSLocalizedString("Invalid PIN", comment: "Invalid PIN title")
        static let invalidPin = NSLocalizedString("The passcode you entered does not match, please try again.", comment: "Invalid PIN message")
        static let scannerErrorTitle = NSLocalizedString("Scanner Error", comment: "QR scanner error title")
        static let scannerErrorMessage = NSLocalizedString("Failed to process QR code, please exit this screen and try again.", comment: "Scanner error message body")
        static let invalidAddressTitle = NSLocalizedString("Invalid Address", comment: "Invalid address warning")
        static let invalidAddressMessage = NSLocalizedString("That address is invalid, please enter a valid address.", comment: "Invalid address message")
    }
    
    struct Labels {
        static let confirmPin = NSLocalizedString("Enter PIN again to confirm", comment: "Confirm PIN message")
        static let complete = NSLocalizedString("Complete", comment: "Complete label text")
    }
}
