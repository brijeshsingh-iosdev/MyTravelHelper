//
//  APIConstant.swift
//  MyTravelHelper
//
//  Created by Brijesh Singh on 13/04/21.
//

import Foundation

/// HTTP Methods
enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

///Album Service URLs
struct AppService {
    static let baseURL = "http://api.irishrail.ie/realtime/realtime.asmx/"
}

/// API path Enum
enum StationAPI {
    case allStations
    case trainsFromSource(sourceCode: String)
    case trainsForDestination(trainCode: String, dateString: String)
}

extension StationAPI: APIRequestProtocol {
    var baseURL: URL? {
        return URL(string: AppService.baseURL)
    }
    
    var path: String {
        switch self {
        case .allStations:
            return "getAllStationsXML"
        case .trainsFromSource(let sourceCode):
            return "getStationDataByCodeXML?StationCode=\(sourceCode)"
        case .trainsForDestination(let trainCode, let dateString):
            return "getTrainMovementsXML?TrainId=\(trainCode)&TrainDate=\(dateString)"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .GET
    }
    
    var requestBody: Data? {
        return nil
    }
    
    var header: HTTPHeaders {
        return ["Content-Type": "application/xml"]
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        return URLRequest.CachePolicy.reloadIgnoringCacheData
    }
    
    var requestTimeOutInterval: TimeInterval {
        return 30.0
    }
}
