//
//  MovieCellModel.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 10/09/2022.
//

import Foundation
import RxCocoa
import RxSwift

protocol MovieCellModelType {
    var id: Int? { get set }
    var artworkURL: Driver<URL?> { get set }
    var artworData: Driver<Data?> { get set }
    var name: Driver<String> { get set }
    var desc: Driver<String> { get set }
    var price: Driver<String> { get set }
    var genre: Driver<String> { get set }
    var isFavorite: Driver<Bool> { get set }
}

class MovieCellModel: MovieCellModelType {
    var id: Int?
    var artworkURL: Driver<URL?>
    var artworData: Driver<Data?>
    var name: Driver<String>
    var desc: Driver<String>
    var price: Driver<String>
    var genre: Driver<String>
    var isFavorite: Driver<Bool>
    
    init(with movie: MovieDataType) {
        self.id = movie.id
        self.artworkURL = Driver.just(URL(string: movie.artwork.orStringEmpty))
        self.artworData = Driver.just(movie.artworkData)
        self.name = Driver.just(movie.name.orStringEmpty)
        self.desc = Driver.just(movie.shortDesc.orStringEmpty)
        self.price = Driver.just("$\(movie.price.orZero)")
        self.genre = Driver.just(movie.genre.orStringEmpty)
        self.isFavorite = Driver.just(movie.isFavorite.orFalse)
    }
}
