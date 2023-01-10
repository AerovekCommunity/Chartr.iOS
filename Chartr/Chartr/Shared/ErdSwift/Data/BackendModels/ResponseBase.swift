//
//  ResposeBase.swift
//  Chartr
//
//  Created by Jay Martinez on 5/9/22.
//

struct ResponseBase<T: Decodable>: Decodable {
    let data: T
    let code: String
    let error: String?
}
