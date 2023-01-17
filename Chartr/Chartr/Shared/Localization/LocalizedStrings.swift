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
