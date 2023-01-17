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
import Hyperspace
import BrightFutures

class PlaidService {
    static let redirectUri = "https://aerovek.com/link/oauth/a2a-redirect.html"
    let backendService: BackendService
    
    let baseUrl = URL(string: "https://restful.aerovek.com:8000/api")!
    
    init() {
        self.backendService = BackendService()
    }
    
    func createLinkToken(for userId: String) -> Future<ResponseBase<LinkTokenResponse>, AnyError> {
        let url = self.baseUrl.appendingPathComponent("create_link_token")
        
        let requestBody = try? JSONEncoder().encode(LinkTokenRequest(userId: userId))
        if let requestBody = requestBody {
            let request: Request<ResponseBase<LinkTokenResponse>, AnyError> = Request(
                method: .post,
                url: url,
                headers: [HTTP.HeaderKey.contentType: HTTP.HeaderValue.applicationJSON],
                body: HTTP.Body(requestBody)) { response in
                    guard let body = response.body else { return .failure(AnyError(PlaidNetworkError.createTokenResponse)) }
                    do {
                        let result = try JSONDecoder().decode(ResponseBase<LinkTokenResponse>.self, from: body)
                        return .success(result)
                    } catch {
                        return .failure(AnyError(error))
                    }
                }
            return self.getResponse(request)
        } else {
            return Future(error: AnyError(PlaidNetworkError.createTokenResponse))
        }
    }
    
    func exchangeAccessToken(with publicToken: String, accountId: String) -> Future<ResponseBase<String>, AnyError> {
        let url = self.baseUrl.appendingPathComponent("set_access_token")
        
        let requestBody = try? JSONEncoder().encode(TokenExchangeRequest(publicToken: publicToken, accountId: accountId))
        if let requestBody = requestBody {
            let request: Request<ResponseBase<String>, AnyError> = Request(
                method: .post,
                url: url,
                headers: [HTTP.HeaderKey.contentType: HTTP.HeaderValue.applicationJSON],
                body: HTTP.Body(requestBody)) { response in
                    guard let body = response.body else { return .failure(AnyError(PlaidNetworkError.createTokenResponse)) }
                    do {
                        let result = try JSONDecoder().decode(ResponseBase<String>.self, from: body)
                        return .success(result)
                    } catch {
                        return .failure(AnyError(error))
                    }
                }
            return self.getResponse(request)
        } else {
            return Future(error: AnyError(PlaidNetworkError.createTokenResponse))
        }
    }
    
    // MARK: Private
    private func getResponse<T>(_ request: Request<T, AnyError>) -> Future<T, AnyError> {
        return self.backendService.execute(request: request)
            .map { (result: T) in
                return result
            }
            .mapError {
                print("ERROR in PlaidService.getResponse -----> \($0.error.localizedDescription) ----- \($0.failureResponse?.statusMessage ?? "")")
                return $0
            }
    }
    
}
