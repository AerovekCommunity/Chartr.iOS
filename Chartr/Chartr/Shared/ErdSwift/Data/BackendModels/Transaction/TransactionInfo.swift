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
