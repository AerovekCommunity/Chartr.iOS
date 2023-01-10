//
//  ElrondService.swift
//  Chartr
//
//  Created by Jay Martinez on 5/7/22.
//

import Foundation
import Hyperspace
import BrightFutures
import BigInt

public class ElrondService {
    
    
    var gatewayUrl: URL
    var apiUrl: URL
    var aeroTokenId: String
    
    private let backendService: BackendService
    
    init(gatewayUrl: URL, apiUrl: URL, aeroTokenId: String) {
        self.gatewayUrl = gatewayUrl
        self.apiUrl = apiUrl
        self.aeroTokenId = aeroTokenId
        self.backendService = BackendService()
    }
    
    // MARK: Public
    
    /// https://gateway.elrond.com/network/config
    /// Queries basic details about the configuration of the network.
    ///  - Returns A future containing the NetworkConfig data.
    func getNetworkConfig() -> Future<ResponseBase<NetworkConfig>, AnyError> {
        let url = self.gatewayUrl.appendingPathComponent("network/config")
        let request: Request<ResponseBase<NetworkConfig>, AnyError> = Request(method: .get, url: url)
        return self.getResponse(request)
    }
    
    /// https://gateway.elrond.com/address/:bech32Address
    /// Retrieves basic information about an Address (Account). Use this to return the EGLD balance.
    ///  - Parameter bech32: The bech32 address to get the account information for.
    ///  - Returns A future containing the Account data.
    func getAccount(bech32: String) -> Future<ResponseBase<Account>, AnyError> {
        let url = self.gatewayUrl.appendingPathComponent("address/\(bech32)")
        let request: Request<ResponseBase<Account>, AnyError> = Request(method: .get, url: url)
        return self.getResponse(request)
    }
    
    /// https://devnet-api.elrond.com/accounts/:address/tokens/:token
    /// Retrieves details about the AERO token for a given address
    ///   - Parameter bech32: The address to retrieve the AERO token details for
    ///   - Returns A future containing the populated AccountToken object
    func getAeroTokenDetails(bech32: String) -> Future<AccountToken, AnyError> {
        let url = self.apiUrl.appendingPathComponent("accounts")
            .appendingPathComponent(bech32)
            .appendingPathComponent("tokens")
            .appendingPathComponent(aeroTokenId)
        
        let request: Request<AccountToken, AnyError> = Request(method: .get, url: url)
        return self.getResponse(request)
    }
    
    /// https://gateway.elrond.com/address/:bech32Address/nonce
    /// Retrieves the nonce of an Address.
    ///  - Parameter bech32: The bech32 address to get the address nonce for.
    ///  - Returns A future containing the AddressNonce for the address passed in.
    func getAddressNonce(bech32: String) -> Future<ResponseBase<AddressNonce>, AnyError> {
        let url = self.gatewayUrl.appendingPathComponent("address/\(bech32)/nonce")
        let request: Request<ResponseBase<AddressNonce>, AnyError> = Request(method: .get, url: url)
        return self.getResponse(request)
    }
    
    /// https://gateway.elrond.com/transaction/send
    /// Sends a signed Transaction to the blockchain.
    /// For Nodes (Observers or Validators with the HTTP API enabled), this endpoint only accepts transactions whose sender is in the Node's Shard.
    ///  - Parameter transactionData: The signed transaction Data.
    ///  - Returns A future containing the response object which will contain the transaction hash.
    func sendTransaction(transactionData: Data?) -> Future<ResponseBase<SendTransactionResponse>, AnyError> {
        let url = self.gatewayUrl.appendingPathComponent("transaction/send")
        
        // Send the POST request with the encoded transaction data
        // The closure will have the response body in it which will be the transaction hash
        if let data = transactionData {
            let request: Request<ResponseBase<SendTransactionResponse>, AnyError> = Request(
                    method: .post,
                    url: url,
                    body: HTTP.Body(data)) { response in
                        guard let body = response.body else { return .failure(AnyError(ElrondServiceError.invalidTransactionData(msg: "[sendTransaction] The response body must have been null"))) }
                        do {
                            let result = try JSONDecoder().decode(ResponseBase<SendTransactionResponse>.self, from: body)
                            return .success(result)
                        } catch {
                            return .failure(AnyError(error))
                        }
                    }
            
            return self.getResponse(request)
        } else {
            return Future(error: AnyError(ElrondServiceError.invalidTransactionData(msg: "No valid transaction data was passed to the function")))
        }
    }
    
    /// https://gateway.elrond.com/transaction/simulate
    /// Send a signed Transaction to the Blockchain in order to simulate its execution.
    /// This can be useful in order to check if the transaction will be successfully executed before actually sending it. It receives the same request as the /transaction/send endpoint.
    /// On the Proxy side, if the transaction to simulate is a cross-shard one, then the response format will contain two elements called senderShard and receiverShard which are of type SimulateTransactionResult.
    func validateTransaction(transactionData: Data?) -> Future<ResponseBase<SimulateTransactionResponse>, AnyError> {
        let url = self.gatewayUrl.appendingPathComponent("transaction/simulate")
        
        if let data = transactionData {
            let request: Request<ResponseBase<SimulateTransactionResponse>, AnyError> = Request(
                    method: .post,
                    url: url,
                    body: HTTP.Body(data)) { response in
                        guard let body = response.body else { return .failure(AnyError(ElrondServiceError.invalidTransactionData(msg: "[sendTransaction] The response body must have been null"))) }
                        do {
                            let result = try JSONDecoder().decode(ResponseBase<SimulateTransactionResponse>.self, from: body)
                            return .success(result)
                        } catch {
                            return .failure(AnyError(error))
                        }
                    }
            
            return self.getResponse(request)
        } else {
            return Future(error: AnyError(ElrondServiceError.invalidTransactionData(msg: "No valid transaction data was passed to the function")))
        }
    }
    
    
    // MARK: Private
    private func getResponse<T>(_ request: Request<T, AnyError>) -> Future<T, AnyError> {
        return self.backendService.execute(request: request)
            .map { (result: T) in
                return result
            }
            .mapError {
                return $0
            }
    }
}
