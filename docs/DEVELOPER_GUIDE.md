# Developer Guide

## Overview
This document will serve to help developers wanting to contribute to the project by covering things like app architecture, third party libraries used for major functions, as well as how the app interacts with the Elrond blockchain.

## Coding Standards
It's highly encouraged to follow the existing coding standards which has not been formerly defined, but the project pretty much follows the [SOLID Principles](https://www.freecodecamp.org/news/solid-principles-explained-in-plain-english/) as well as the DRY (Don't Repeat Yourself) pattern. Keeping this in mind will help keep the app maintainable and easy to follow for other developers.

## Project Structure
* All of the storyboards and view controllers are in the *Screens* folder.
* The *Shared* folder contains things like reusable UI components (such as custom controls), custom styling classes, network and data classes, etc. Anything that is shared or accessed across the app.
* The app uses a Podfile which means you need to open the xcworkspace to open the project.

## Development Environment
* Latest Mac OS version
* Latest Xcode version
* iPhone with iOS version 14 or later - the app will not run in a simulator, additional work must be done to support this.

## Third Party Frameworks
* [Hyperspace](https://github.com/BottleRocketStudios/iOS-Hyperspace) is used for making HTTP calls.
* [BrightFutures](https://github.com/Thomvis/BrightFutures) is used for async handling. This has reached end of life and will need to be replaced by Swift's Async/Await pattern.
* [BigInt](https://github.com/attaswift/BigInt) is used to store and operate on large values such as wallet balances.
* [TrustWalletCore v2.3.9](https://github.com/trustwallet/wallet-core) is used for all the cryptographic operations such as transaction signing and wallet creation. It supports the Elrond token, but at the time the only version that worked for me was 2.3.9. Perhaps the latest version now works.
[KeychainSwift](https://github.com/evgenyneu/keychain-swift) is used to store the user's wallet private key securely. 
[Plaid](https://github.com/plaid/plaid-link-ios) was used to POC the Plaid integration.
[lottie-ios](https://github.com/airbnb/lottie-ios) used for animations.

## Note about Plaid
Plaid is essentially a third party integration that allows our app to connect to bank accounts for verifying funds. I left the code here in case we decide to implement it. I successfully POC'd it in the Plaid sandbox environment using our plaid backend server (which I can make public if requested). 

## Network Calls
Network calls are done using a package called Hyperspace. See [ElrondService](../Chartr/Chartr/Shared/ErdSwift/Network/ElrondService.swift) on  how to use it correctly, and how to define your return types and how to handle successful responses vs failed responses.

Returning from an async network call is done using callbacks, there’s a success and failure callback. The success callback should pass the return object depending on the return type you defined in your service method.

## ErdSwift
This folder can essentially be converted into a framework and used in other apps. It has the core functionality needed to interact with the Elrond blockchain. 

Most of what is in this folder are data structures that represent the payloads you get back from making various blockchain API calls, and the ElrondService.swift class has methods for many of the common network operations such as 
* Retrieving an account to get a wallet's EGLD balance 
* Retrieving AERO token details for a wallet's AERO balance 
* A ```sendTransaction``` method that sends a signed transaction 
* etc 

It would be nice to move all the WalletCore functions inside there, like signing transactions etc, that way you can define the WalletCore dependency in the ErdSwift framework instead of your client application. That might be more work than it’s worth but wanted to mention it.

### **Cryptographic Operations**
The transaction signing and wallet creation, and anything having to do with crypto functions, is done using TrustWallet’s WalletCore library  version 2.3.9. Newer versions of the library did not work at the time (if it ain't broke don't fix it).

### **Creating New Wallet**
The [ErdSdk](../Chartr/Chartr/Shared/ErdSwift/ErdSdk.swift) class has a method named ```createNewWallet()```
```
func createNewWallet() -> HDWallet {
    return HDWallet(strength: 256, passphrase: "")
}
```

After either creating a new wallet or importing an existing one, the wallet private key and the 24 word mnemonic are stored in secure storage using the KeychainSwift library.

When signing a transaction, the wallet private key is read from there and used in the signingInput (see example below)

```
guard let privateKey = keychain.getData(KeychainKeys.walletPrivateKey) else { fatalError("Could not find private key in keychain storage") }

var signerInput = ElrondSigningInput.with {
    $0.privateKey = privateKey
    $0.transaction = ElrondTransactionMessage.with {
        $0.nonce = UInt64(nonce)
        $0.receiver = toAddress
        $0.sender = address
        $0.gasPrice = UInt64(minGasPrice)
        $0.gasLimit = UInt64(minGasLimit)
        $0.chainID = chainId
        $0.version = UInt32(transactionVersion)
    }
}

```

### **Importing Existing Wallet**
Similar to creating a new wallet but instead we use the 24 word mnemonic to generate the wallet. So obviously the user needs to provide this beforehand..
```
func importWallet(with mnemonic: String) -> HDWallet {
    return HDWallet(mnemonic: mnemonic, passphrase: "")
}
```

## Deploying to TestFlight
It is recommended to use [Fastlane](https://docs.fastlane.tools/getting-started/ios/setup/) for building and deploying.
Once fastlane is setup on your local machine you can start issuing fastlane commands for all types of things.
In the fastlane folder there is a file called [Fastfile](../fastlane/Fastfile) that has a lane called “uploadToTestflight”. 
From a terminal all you need to do is run 

```
bundle exec fastlane uploadToTestFlight
```
 
I highly recommend reading about Fastlane if you don’t know how it works. There are actions for just about anything you need to do, for both Android and iOS.

