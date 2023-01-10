//
//  BackendService+Futures.swift
//  Chartr
//
//  Created by Jay Martinez on 5/9/22.
//

import BrightFutures
import Hyperspace

extension BackendServiceProtocol {

    /// Executes the Request, returning a Future when finished.
    ///
    /// - Parameters:
    ///   - request: The Request to be executed.
    /// - Returns: A Future<T> that resolves to the request's response type.
    public func execute<T, U>(request: Request<T, U>) -> Future<T, U> {
        let promise = Promise<T, U>()
        
        execute(request: request) { result in
            promise.complete(result)
        }
        
        return promise.future
    }
}
