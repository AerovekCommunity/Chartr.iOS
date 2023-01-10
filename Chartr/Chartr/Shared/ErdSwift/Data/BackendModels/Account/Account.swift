//
//  AccountData.swift
//  Chartr
//
//  Created by Jay Martinez on 5/9/22.
//

class Account: Decodable {
    let account: AccountData
    
    struct AccountData: Decodable {
        let address: String
        let ownerAddress: String
        let nonce: Int
        let balance: String
        let code: String?
        let username: String?
    }
}
