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

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Create singleton instance of ErdSdk, all calls should
        // then be made using the shared instance (i.e. ErdSdk.shared.elrondService.getNetworkConfig())
        ErdSdk.shared = ErdSdk()
        
        #if DEBUG
        print("USING:------> \(ErdSdk.shared.elrondService.gatewayUrl)")
        #endif
        
        window = UIWindow(windowScene: windowScene)
        let navigationController = ChartrNavigationController()
        window?.rootViewController = navigationController
        window?.backgroundColor = AppColor.white.color
        window?.makeKeyAndVisible()
        
        var initialViewControllers: [UIViewController] = []
        
        // Start by adding the homepage as the root, after creating an account
        // we will pop to root and end up on the home screen
        guard let homeViewController: HomeViewController = UIStoryboard(name: "Home", bundle: nil)
            .instantiateInitialViewController() as? HomeViewController else { fatalError("Unable to instantiate HomeViewController") }
        initialViewControllers.append(homeViewController)
        
        // If no userPin was set they need to setup a new account with a new or existing wallet
        if UserDefaults.standard.string(forKey: UserDefaultsKeys.userPin) == nil {
            // If user uninstalled the app the keychain values will still be there
            // so we should remove them now
            let keychain = KeychainSwift()
            keychain.delete(KeychainKeys.walletWords)
            keychain.delete(KeychainKeys.walletPrivateKey)
            
            let obv = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            initialViewControllers.append(obv)
            navigationController.setViewControllers(initialViewControllers, animated: false)
        } else {
            let keychain = KeychainSwift()
            let words = keychain.get(KeychainKeys.walletWords)
            print("WALLET WORDS: \(words ?? "n/a")")
            navigationController.setViewControllers(initialViewControllers, animated: false)
            guard let pinPadViewController: PinPadViewController = UIStoryboard(name: "PinPad", bundle: nil)
                .instantiateViewController(withIdentifier: "PinPad") as? PinPadViewController else { fatalError("Unable to instantiate PinPadViewController") }
            
            pinPadViewController.isModalInPresentation = true
            pinPadViewController.initialize(isCreatingNewPin: false) { (pin, isSuccessful) in
                if isSuccessful {
                    navigationController.dismiss(animated: true)
                }
            }
            
            navigationController.present(pinPadViewController, animated: true)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    // MARK: Continue Plaid Link for iOS to complete an OAuth authentication flow
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb, let webpageURL = userActivity.webpageURL else {
            return false
        }

        // The Plaid Link SDK ignores unexpected URLs passed to `continue(from:)` as
        // per Apple’s recommendations, so there is no need to filter out unrelated URLs.
        // Doing so may prevent a valid URL from being passed to `continue(from:)` and
        // OAuth may not continue as expected.
        // For details see https://plaid.com/docs/link/ios/#set-up-universal-links
        guard let linkOAuthHandler = window?.rootViewController as? LinkOauthHandling,
            let handler = linkOAuthHandler.linkHandler
        else {
            return false
        }

        // Continue the Link flow
        handler.continue(from: webpageURL)
        return true
    }

}

