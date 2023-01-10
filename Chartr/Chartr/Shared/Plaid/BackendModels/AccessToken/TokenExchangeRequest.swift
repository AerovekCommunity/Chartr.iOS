//
//  PublicTokenExchangeRequest.swift
//  Chartr
//
//  Created by Jay Martinez on 5/28/22.
//

struct TokenExchangeRequest: Codable {
    let publicToken: String
    let accountId: String
    
    init (publicToken: String, accountId: String) {
        self.publicToken = publicToken
        self.accountId = accountId
    }
}
     
