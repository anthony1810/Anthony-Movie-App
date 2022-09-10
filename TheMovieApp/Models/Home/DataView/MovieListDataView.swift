//
//  MovieListDataView.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 10/09/2022.
//


protocol MovieListDataType {
    var resultCount: Int? { get }
    var results: [MovieDataType] { get set }
}

class MovieListDataView: MovieListDataType {
    var resultCount: Int?
    var results: [MovieDataType]
    
    init(model: MovieListModel) {
        self.resultCount = model.resultCount
        self.results = model.results.orArrEmpty.compactMap { MovieDataView(input: $0) }
    }
}
