//
//  MovieDetailCellModel.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 12/09/2022.
//

import RxSwift
import Foundation
import RxCocoa

protocol MovieDetailCellModelType {
    var artworkURL: Driver<URL?> { get set }
    var artworkData: Driver<Data?> { get set }
    var name: Driver<String> { get set }
    var desc: Driver<String> { get set }
    var price: Driver<String> { get set }
    var genre: Driver<String> { get set }
    var isFavorite: Driver<Bool> { get set }
    var longDesc: Driver<String> { get set }
}

class MovieDetailCellModel: MovieDetailCellModelType {
    var artworkURL: Driver<URL?>
    var artworkData: Driver<Data?>
    var name: Driver<String>
    var desc: Driver<String>
    var price: Driver<String>
    var genre: Driver<String>
    var isFavorite: Driver<Bool>
    var longDesc: Driver<String>
    
    init(with movie: MovieDataType) {
        self.artworkURL = Driver.just(URL(string: movie.artwork.orStringEmpty))
        self.artworkData = Driver.just(movie.artworkData)
        self.name = Driver.just(movie.name.orStringEmpty)
        self.desc = Driver.just(movie.shortDesc.orStringEmpty)
        self.price = Driver.just("$\(movie.price.orZero)")
        self.genre = Driver.just(movie.genre.orStringEmpty)
        self.isFavorite = Driver.just(movie.isFavorite.orFalse)
        self.longDesc = Driver.just(movie.longDesc.orStringEmpty)
    }
}
