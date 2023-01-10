//
//  ViewController.swift
//  Chartr
//
//  Created by Jay Martinez on 5/18/22.
//

import UIKit
import LinkKit

protocol LinkOauthHandling {
    var linkHandler: Handler? { get }
}

class MainController: UIViewController, LinkOauthHandling {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    
    let plaidService = PlaidService()
    var linkHandler: Handler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginButtonClicked(_ sender: Any) {
        /*
        guard let pinPadViewController: PinPadViewController = UIStoryboard(name: "PinPad", bundle: nil)
            .instantiateViewController(withIdentifier: "PinPad") as? PinPadViewController else { fatalError("Unable to instantiate PinPadViewController") }
        self.navigationController?.present(pinPadViewController, animated: true)
         */
        
        // TODO remove, simulating for testing
        let userId = UUID().uuidString
        self.initializeLink(userId: userId)
    }
}
