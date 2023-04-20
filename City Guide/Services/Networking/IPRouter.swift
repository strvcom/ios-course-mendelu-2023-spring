//
//  IPRouter.swift
//  City Guide
//
//  Created by Martin Vidovic on 17.04.2023.
//

import Foundation

enum IPRouter {
    case getIP
    case getIPInfo(ipAddress: String)
}

extension IPRouter: Router {
    var baseURL: String {
        switch self {
        case .getIP:
            return "https://api.ipify.org"
        case .getIPInfo:
            return "https://ipinfo.io"
        }
    }
    var path: String {
        switch self {
        case .getIP:
            return ""
        case let .getIPInfo(ipAddress):
            return "\(ipAddress)/geo"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getIP:
            return .get
        case .getIPInfo:
            return .get
        }
    }
    
    var urlParameters: [String : Any]? {
        switch self {
        case .getIP:
            return ["format": "json"]
        case .getIPInfo:
            return nil
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}
