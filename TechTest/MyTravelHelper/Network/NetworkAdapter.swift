//
//  NetworkAdapter.swift
//  MyTravelHelper
//
//  Created by Brijesh Singh on 13/04/21.
//

import Foundation

final class NetworkAdapter {
    
    // MARK: - Properties
    private let session: URLSession
    static let shared = NetworkAdapter(with: URLSession.shared)

    // MARK: - Constructor
    
    private init(with session: URLSession) {
        self.session = session
    }
    
    // MARK: - API Call
    /// Triggers API call with a completion call back containing the rsponse data and an Error instance
    /// - Parameters:
    ///    - request: `APIRequestProtocol` type parameter which consists of all the details required for triggering the API
    ///    - onCompletionHandler: A Completion callback containing an optional `Data` and `NetworkError` instance
    func requestAPI(with request: APIRequestProtocol, onCompletionHandler: @escaping ((_ result: Result<Data?, NetworkError>) -> Void)) {
        
        guard let baseURL = request.baseURL, let urlStr = (baseURL.appendingPathComponent(request.path)).absoluteString.removingPercentEncoding, let url = URL(string: urlStr) else {
            onCompletionHandler(.failure(.clientError))
            return
        }
    
        var urlRequest = URLRequest(url: url,
                                    cachePolicy: request.cachePolicy,
                                    timeoutInterval: request.requestTimeOutInterval)
        
        urlRequest.httpMethod = request.httpMethod.rawValue
        
        if let requestBody = request.requestBody {
            urlRequest.httpBody = requestBody
        }
        
        for key in request.header.keys {
            urlRequest.setValue(request.header[key], forHTTPHeaderField: key)
        }

        session.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data {
                onCompletionHandler(.success(data))
            } else if let _ = error, let response = response as? HTTPURLResponse {
                onCompletionHandler(.failure(NetworkError.getErrorType(fromErrorCode: response.statusCode)))
            } else {
                onCompletionHandler(.failure(.unknown))
            }
        }.resume()
    }
}
