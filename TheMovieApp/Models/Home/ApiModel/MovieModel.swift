//
//  Movie.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 10/09/2022.
//

import Foundation
import ObjectMapper

/// Original representation  of movie item from Itune Search API
struct MovieModel: Mappable {
    var trackId: Int?
    var trackName: String?
    var artworkUrl30: String?
    var artworkUrl60: String?
    var artworkUrl100: String?
    var trackPrice: Double?
    var primaryGenreName: String?
    var longDescription: String?
    var shortDescription: String?
    
    init?(map: Map) { }
    
    init() { }
    
    mutating func mapping(map: Map) {
        trackId <- map["trackId"]
        trackName <- map["trackName"]
        artworkUrl30 <- map["artworkUrl30"]
        artworkUrl60 <- map["artworkUrl60"]
        artworkUrl100 <- map["artworkUrl100"]
        trackPrice <- map["trackPrice"]
        primaryGenreName <- map["primaryGenreName"]
        longDescription <- map["longDescription"]
        shortDescription <- map["shortDescription"]
    }
}
