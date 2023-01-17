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

import LinkKit

extension MainController {
    
    func createLinkTokenConfig(linkToken: String) -> LinkTokenConfiguration {
        var config = LinkTokenConfiguration(token: linkToken) { success in
            print("public-token: \(success.publicToken) metadata: \(success.metadata)")
            
            // TODO We now have successfully finished the link process. But now how do
            // we communicate with the bank going forward without having to go through this login
            // process every time?
            
            // The publicToken sent back here will now be sent up to our server. This needs to happen
            // right away because the token only lasts about 30 minutes. Our server will send that
            // publicToken to Plaid who will then verify the token and exchange it for an Access Token
            // and send that back to our server.
            
            // The access token is associated with the user and that association should be stored in
            // a database somewhere. The access token is also associated with the Item that was created
            // after connecting to the bank. An Item is basically a bank login object with one or more
            // accounts, connect info, recent transactions, etc.
            
            // Now any calls to retrieve bank account data will be server to server calls
            // using that access token (along with the clientId and secret)
            
            let accounts = success.metadata.accounts
            var account: LinkKit.Account?
            
            if accounts.count == 1 {
                account = success.metadata.accounts[0]
            } else if accounts.count > 0 {
                let checking = accounts.filter {
                    $0.subtype.description == "checking"
                }
                let savings = accounts.filter {
                    $0.subtype.description == "savings"
                }
                
                if checking.count > 0 {
                    account = checking[0]
                } else if savings.count > 0 {
                    account = savings[0]
                }
                
                if let account = account {
                    self.plaidService.exchangeAccessToken(with: success.publicToken, accountId: account.id)
                        .onSuccess { result in
                            print("Exchange token response DATA: \(result.data)")
                            print("Exchange token response CODE: \(result.code)")
                            print("Exchange token response ERROR: \(result.error ?? "none")")
                            
                            if (result.data == "OK") {
                                // TODO remove, this is for testing
                                let alert = UIAlertController(title: "Success!", message: "You successfully connected your bank \(success.metadata.institution.name) and access token was exchanged successfully, we can now query bank details!", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                                    self.dismiss(animated: true)
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        .onFailure { error in
                            print("ERROR!! -- \(error.localizedDescription)")
                            let alert = UIAlertController(title: "Fail!", message: "Some error occurred while exchanging public token for access token!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                                self.dismiss(animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    
                } else {
                    fatalError("Failed to determine which account to use from these accounts: \(success.metadata.accounts)")
                }
            }
        }
        
        config.onExit = { exit in
            if let error = exit.error {
                // TODO - this closure is optional but this is where we can
                // log when a user closes the link flow without completing it
                print("Link exit with \(error)\n\(exit.metadata)")
            } else {
                print("Link exit with \(exit.metadata)")
            }
        }
        
        config.onEvent = { evt in
            // An optional closure that is called when a user reaches certain points in the Link flow.
            print("Link Event: \(evt)")
        }
        
        return config
    }
    
    /// Generates a link token from the Plaid API. This should only be called when the user is ready to connect their bank
    /// as the link token will expire.
    func initializeLink(userId: String) {
        
        plaidService.createLinkToken(for: userId)
            .onSuccess { result in
                print("Create Link token response DATA: \(result.data)")
                print("Create Link token response CODE: \(result.code)")
                
                let linkConfig = self.createLinkTokenConfig(linkToken: result.data.linkToken)
                let result = Plaid.create(linkConfig)
                switch result {
                case .failure(let error):
                    print("Unable to create Plaid handler due to: \(error)")
                case .success(let handler):
                    handler.open(presentUsing: .viewController(self))
                    self.linkHandler = handler
                }
            }
            .onFailure { err in
                print("----> FAILURE TO GET LINK TOKEN: \(err.localizedDescription)")
                // TODO what to do in this case?
            }
    }
    
}
