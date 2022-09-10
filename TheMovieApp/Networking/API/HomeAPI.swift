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
    public var baseURL: URL { return Environment.apiUrl }
    public var path: String {
        switch self {
        case .search(let term):
            return "term=\(term)&country=au&media=movie&;all"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Task {
        switch self {
        case .search:
              return .requestPlain
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
