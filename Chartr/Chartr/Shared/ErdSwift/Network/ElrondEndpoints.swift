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


enum ElrondEndpoints {
    
    // MARK: Address
    
    /// [GET] https://gateway.elrond.com/address/:bech32Address
    /// Retrieve basic information about an Address (Account).
    case account
    
    /// [GET] https://gateway.elrond.com/address/:bech32Address/balance
    /// Retrieve the balance of an Address.
    case addressBalance
    
    /// [GET] https://gateway.elrond.com/address/:bech32Address/nonce
    /// Retrieve the nonce of an Address.
    case addressNonce
    
    /// [GET]  https://gateway.elrond.com/address/:bech32Address/transactions
    /// Retrieve the latest 20 Transactions sent from an Address.
    /// This endpoint is not available on Observer Nodes. It is only available on Elrond Proxy.
    case addressTransactions
    
    /// [GET]  https://gateway.elrond.com/address/:bech32Address/key/:key
    /// Retrieve a value stored within the Blockchain for a given Address.
    case storageValueForAddress
    
    /// [GET] https://gateway.elrond.com/address/:bech32Address/keys
    /// Retrieve all the key-value pairs stored under a given account
    case allStorageForAddress
    
    // MARK: Transaction
    
    /// [POST] https://gateway.elrond.com/transaction/cost
    /// Estimate the cost of a transaction.
    /// This endpoint returns the cost of the transaction in gas units. The returned value can be used to fill in gasLimit field of the transaction.
    case estimateCostOfTransaction
    
    /// [POST] https://gateway.elrond.com/transaction/send
    /// Send a signed Transaction to the blockchain.
    /// For Nodes (Observers or Validators with the HTTP API enabled), this endpoint only accepts transactions whose sender is in the Node's Shard.
    case sendTransaction
    
    /// [POST] https://gateway.elrond.com/transaction/send-multiple
    /// Send a bulk of Transactions to the blockchain.
    /// For Nodes (Observers or Validators with the HTTP API enabled), this endpoint only accepts transactions whose sender is in the Node's Shard.
    case sendMultipleTransactions
    
    /// [POST] https://gateway.elrond.com/transaction/simulate
    /// Send a signed Transaction to the Blockchain in order to simulate its execution.
    /// This can be useful in order to check if the transaction will be successfully executed before actually sending it. It receives the same request as the /transaction/send endpoint.
    /// On the Proxy side, if the transaction to simulate is a cross-shard one, then the response format will contain two elements called senderShard and receiverShard which are of type SimulationResults.
    case simulateSendTransaction
    
    /// [GET] https://gateway.elrond.com/transaction/:txHash
    /// Query the details of a Transaction.
    case transactionDetails
    
    /// [GET] https://gateway.elrond.com/transaction/:txHash/status
    /// Query the status of a Transaction.
    case transactionStatus
    
    // MARK: Network
    
    /// [GET]  https://gateway.elrond.com/network/config
    /// Query basic details about the configuration of the network
    case networkConfig
    
    /// https://gateway.elrond.com/network/status/:shardId
    /// [GET] Query the status of a given shard.
    /// The path parameter shardId is only applicable on the Proxy endpoint. The Observer endpoint does not define this parameter.
    case shardStatus
    
}
