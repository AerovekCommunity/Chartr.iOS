//
//  TransactionInfoDto.swift
//  Chartr
//  This struct is meant to be used to receive the response from 

//  Created by Jay Martinez on 5/11/22.
//

import BigInt

struct TransactionInfo: Decodable {
    let transaction: TransactionInfoData
    
    struct TransactionInfoData: Decodable {
        let type: String
        let nonce: Int64
        let round: Int64
        let epoch: Int64
        let value: String
        let sender: String
        let receiver: String
        let senderUsername: String?
        let receiverUsername: String?
        let gasPrice: Int64
        let gasLimit: Int64
        let data: String?
        let signature: String
        let sourceShard: Int64
        let destinationShard: Int64
        let blockNonce: Int64
        let timestamp: Int64
        let miniBlockHash: String?
        let blockHash: String?
        let status: String
        let hyperblockNonce: Int64?
        let smartContractResults: [SmartContractResult]?
        
        struct SmartContractResult: Decodable {
            let hash: String?
            let nonce: Int64
            let value: String
            let receiver: String
            let sender: String
            let data: String?
            let prevTxHash: String
            let originalTxHash: String
            let gasLimit: Int64
            let gasPrice: Int64
            let callType: String
        }
    }
}
