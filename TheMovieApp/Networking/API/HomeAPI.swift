//
//  HomeAPI.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 18/03/2022.
//

import Moya

public enum HomeAPI {
    case search(term: String)
}

extension HomeAPI: TargetType {
    public var baseURL: URL { return Environment.onlyDomainURL }
    public var path: String {
        switch self {
        case .search:
            return "/search"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Task {
        switch self {
        case .search(let term):
            return .requestParameters(parameters: ["term": term, "country": "au", "media": "movie"], encoding: URLEncoding.queryString)
        }
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
