//
//  MovieList.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 10/09/2022.
//

import Foundation
import ObjectMapper


/// Origin Representation of result from Itune Search API
struct MovieListModel: Mappable {
    var resultCount: Int?
    var results: [MovieModel]?
    
    init() { }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        resultCount <- map["resultCount"]
        results <- map["results"]
    }
}
