//
//  LinkToken.swift
//  Chartr
//
//  Created by Jay Martinez on 5/25/22.
//

struct LinkTokenRequest: Codable {
    let clientName: String
    let userId: String
    
    init(userId: String) {
        self.clientName = "Chartr"
        self.userId = userId
    }
    
    enum CodingKeys: String, CodingKey {
        case clientName = "client_name"
        case userId = "client_user_id"
    }
}
