//
//  ReceiveAeroViewController.swift
//  Chartr
//
//  Created by Jay Martinez on 6/21/22.
//

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
