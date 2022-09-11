//
//  MovieDataView.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 10/09/2022.
//

import Foundation
import DifferenceKit

protocol MovieDataType {
    var id: Int? { get }
    var name: String? { get }
    var artwork: String? { get }
    var price: Double? { get }
    var genre: String? { get }
    var longDesc: String? { get }
    var shortDesc: String? { get }
    
    var isFavorite: Bool? { get set }
}

class MovieDataView: MovieDataType, Equatable {
    
    var id: Int?
    var name: String?
    var artwork: String?
    var price: Double?
    var genre: String?
    var longDesc: String?
    var shortDesc: String?
    
    var isFavorite: Bool?
    
    init?(input model: MovieModel?) {
        guard let data = model,
              let id = data.trackId,
              let trackName = data.trackName,
              let artwork = data.artworkUrl100,
              let trackPrice = data.trackPrice,
              let genre = data.primaryGenreName,
              let longDesc = data.longDescription,
              let shortDesc = data.shortDescription
        else { return nil }
        
        self.id = id
        self.name = trackName
        self.artwork = artwork
        self.price = trackPrice
        self.genre = genre
        self.longDesc = longDesc
        self.shortDesc = shortDesc
        
        self.isFavorite = false
    }
    
    static func == (lhs: MovieDataView, rhs: MovieDataView) -> Bool {
        return lhs.id.orZero == rhs.id.orZero
            && lhs.name.orStringEmpty == rhs.name.orStringEmpty
            && lhs.artwork.orStringEmpty == rhs.artwork.orStringEmpty
            && lhs.price.orZero == rhs.price.orZero
            && lhs.genre.orStringEmpty == rhs.genre.orStringEmpty
            && lhs.longDesc.orStringEmpty == rhs.longDesc.orStringEmpty
            && lhs.shortDesc.orStringEmpty == rhs.shortDesc.orStringEmpty
            && lhs.isFavorite.orFalse == rhs.isFavorite.orFalse
    }
}

extension MovieDataView: Differentiable {
    var differenceIdentifier: Int {
        return id.orZero
    }
    
    func isContentEqual(to source: MovieDataView) -> Bool {
        return self.isEqualTo(source)
    }
}


extension MovieDataType where Self: Equatable {
    func isEqualTo(_ other: MovieDataType) -> Bool {
        guard let other = other as? Self else { return false }
        return self == other
    }
}


