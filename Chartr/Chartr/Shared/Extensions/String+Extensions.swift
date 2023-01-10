//
//  String+Extensions.swift
//  Chartr
//
//  Created by Jay Martinez on 5/9/22.
//

import BigInt

extension String {
    func toBigInt() throws -> BigInt {
        if self.isEmpty { throw CastingError.stringToBigInt }
        guard let value = BigInt(self) else { throw CastingError.stringToBigInt }
        return value
    }
    
    func toDouble() throws -> Double {
        if self.isEmpty { throw CastingError.stringToDouble }
        guard let value = Double(self) else { throw CastingError.stringToDouble }
        return value
    }
}
