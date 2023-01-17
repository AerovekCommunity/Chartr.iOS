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
import CoreImage.CIFilterBuiltins

class ReceiveAeroViewController: UIViewController {
    @IBOutlet weak var walletAddress: ChartrLabel!
    @IBOutlet weak var copyButton: ChartrButton!
    @IBOutlet weak var addressQrImage: UIImageView!
    
    override func viewDidLoad() {
        if let address = UserDefaults.standard.string(forKey: UserDefaultsKeys.walletAddress) {
            walletAddress.text = address
            addressQrImage.image = buildQRCodeImage(address)
            addressQrImage.layer.magnificationFilter = .nearest
        } else {
            walletAddress.text = "Wallet address missing, let Jay know!"
        }
    }
    
    @IBAction func copyTapped(_ sender: Any) {
        UIPasteboard.general.string = walletAddress.text
        showAlert("Copied", "Your address was copied to the clipboard. Do you hate popup dialogs as much as I do???", "Yep") { _ in
            print("TODO")
        }
    }
    
    /// Generates a QR code image from the wallet address string
    private func buildQRCodeImage(_ address: String) -> UIImage {
        let filter = CIFilter.qrCodeGenerator()
        let context = CIContext()
        let addressData = Data(address.utf8)
        
        filter.setValue(addressData, forKey: "inputMessage")
        
        if let qrcode = filter.outputImage {
            if let qrcodeImage = context.createCGImage(qrcode, from: qrcode.extent) {
                return UIImage(cgImage: qrcodeImage)
            }
        }
        
        return UIImage(systemName: "xmark") ?? UIImage()
    }
}
