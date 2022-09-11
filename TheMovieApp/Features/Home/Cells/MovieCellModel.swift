//
//  MovieCellModel.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 10/09/2022.
//

import Foundation
import RxCocoa

protocol MovieCellModelType {
    var artworkURL: Driver<URL?> { get set }
    var name: Driver<String> { get set }
    var desc: Driver<String> { get set }
    var isFavorite: Driver<Bool> { get set }
}

class MovieCellModel: MovieCellModelType {
    var artworkURL: Driver<URL?>
    var name: Driver<String>
    var desc: Driver<String>
    var isFavorite: Driver<Bool>
    
    init(with movie: MovieDataType) {
        self.artworkURL = Driver.just(URL(string: movie.artwork.orStringEmpty))
        self.name = Driver.just(movie.name.orStringEmpty)
        self.desc = Driver.just(movie.shortDesc.orStringEmpty)
        self.isFavorite = Driver.just(movie.isFavorite.orFalse)
    }
}