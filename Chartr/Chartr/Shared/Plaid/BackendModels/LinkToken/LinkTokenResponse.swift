//
//  LinkTokenResponse.swift
//  Chartr
//
//  Created by Jay Martinez on 5/26/22.
//

struct LinkTokenResponse: Codable {
    let expiration: String
    let linkToken: String
    let requestId: String
    
    enum CodingKeys: String, CodingKey {
        case expiration
        case linkToken = "link_token"
        case requestId = "request_id"
    }
}
