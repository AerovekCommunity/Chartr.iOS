//
//  AccountToken.swift
//  Chartr
//
//  Created by Jay Martinez on 6/23/22.
//

struct AccountToken: Codable {
    let identifier: String
    let name: String
    let ticker: String
    let owner: String
    let minted: String
    let burnt: String
    let initialMinted: String
    let decimals: Int
    let isPaused: Bool
    let transactions: Int
    let accounts: Int
    let canUpgrade: Bool
    let canMint: Bool
    let canBurn: Bool
    let canChangeOwner: Bool
    let canPause: Bool
    let canFreeze: Bool
    let canWipe: Bool
    let supply: String
    let circulatingSupply: String
    let balance: String
    //let valueUsd: Double
    //let price: Double
    //let marketCap: Int64
}
