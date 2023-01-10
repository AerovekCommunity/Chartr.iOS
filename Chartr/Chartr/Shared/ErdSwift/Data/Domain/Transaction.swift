//
//  Transaction.swift
//  Chartr
//
//  Created by Jay Martinez on 5/11/22.
//

import Foundation

class Transaction: Codable {
    /// The Nonce of the sender
    var nonce: UInt64
    /// The value to transfer (can be 0)
    var value: String
    /// The bech32 address of the receiver
    var receiver: String
    /// The bech32 address of the sender
    var sender: String
    /// The desired gas price (per gas unit)
    var gasPrice: UInt64
    /// The maximum amount of gas units to consume
    var gasLimit: UInt64
    /// The message (data) of the transaction
    var data: String?
    /// The chain identifier
    var chainID: String
    /// The hex-encoded signature of the transaction
    var signature: String? = nil
    /// The version of the transaction
    var version: UInt32
}
