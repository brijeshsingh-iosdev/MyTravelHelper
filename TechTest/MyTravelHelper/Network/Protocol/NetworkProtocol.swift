//
//  NetworkProtocol.swift
//  MyTravelHelper
//
//  Created by Brijesh Singh on 13/04/21.
//

import Foundation

typealias HTTPHeaders = [String: String]

protocol APIRequestProtocol {
    /// Base URL
    var baseURL: URL? { get }
    /// API Request Path
    var path: String { get }
    /// HTTP Method i.e `GET/POST/PUT/DELETE` to be used for invoking any API call
    var httpMethod: HTTPMethod { get }
    /// Request Data which is required for `POST/PUT `call i.e for adding or updating a contact
    var requestBody: Data? { get }
    /// HTTP Header
    var header: HTTPHeaders { get }
    /// Network Cache Policy
    var cachePolicy: URLRequest.CachePolicy { get }
    /// Timeout intervak
    var requestTimeOutInterval: TimeInterval { get }
}
