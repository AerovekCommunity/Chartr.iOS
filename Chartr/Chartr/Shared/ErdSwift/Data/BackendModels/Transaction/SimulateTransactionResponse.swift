//
//  SimulateTransactionResponse.swift
//  ErdSwift
//
//  Created by Jay Martinez on 5/16/22.
//

struct SimulateTransactionResponse: Codable {
    let result: SimulateTransactionResult
    
    struct SimulateTransactionResult: Codable {
        let receiverShard: ReceiverShard
        let senderShard: SenderShard
        
        struct ReceiverShard: Codable {
            let status: String
            let hash: String
        }
        struct SenderShard: Codable {
            let status: String
            let hash: String
        }
    }
}
