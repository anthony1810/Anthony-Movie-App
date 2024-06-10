//
//  MovieDetailAPI.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 23/03/2022.
//

import Moya
import Foundation
import UIKit
import Foundation
import UIKit
public enum MovieDetailAPI {
    case detail(id: Int)
}

extension MovieDetailAPI: TargetType {
    public var baseURL: URL { return Environment.apiUrl }
    public var path: String {
        switch self {
        case .detail(let id):
            return "/movie/\(id)"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Task {
        return .requestParameters(parameters: ["api_key": Environment.apiKey],
                                  encoding: URLEncoding.default)
    }
    
    public var validationType: ValidationType {
        return .none
    }
    
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    public var headers: [String : String]? {
        return [:]
    }
}
