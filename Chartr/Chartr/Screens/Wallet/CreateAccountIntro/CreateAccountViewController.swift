//
//  CreateAccountViewController.swift
//  Chartr
//
//  Created by Jay Martinez on 6/10/22.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var importWalletBtn: ChartrButton!
    @IBOutlet weak var createWalletBtn: ChartrButton!
    
    private var protectWalletViewController: ProtectWalletViewController!
    
    override func viewDidLoad() {
        guard let protectWalletVC = UIStoryboard(name: "CreateAccount", bundle: nil)
            .instantiateViewController(withIdentifier: "ProtectWallet") as? ProtectWalletViewController
        else { fatalError("Unable to instantiate ProtectWalletViewController") }
        
        protectWalletViewController = protectWalletVC
    }
    
    @IBAction func importWalletTapped(_ sender: Any) {
        print("Import wallet tapped!!!")
        protectWalletViewController.initialize(isNewWallet: false)
        self.navigationController?.pushViewController(protectWalletViewController, animated: true)
    }
    
    @IBAction func createWalletTapped(_ sender: Any) {
        print("Create wallet tapped!!!")
        protectWalletViewController.initialize(isNewWallet: true)
        self.navigationController?.pushViewController(protectWalletViewController, animated: true)
    }
}

extension CreateAccountViewController: NavigableViewController {
    var navBarStyle: NavigationBarStyle { return .white }
}
