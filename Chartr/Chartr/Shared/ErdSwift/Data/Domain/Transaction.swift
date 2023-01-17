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
