//
//  MovieDetailModelType.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 11/09/2022.
//

import RxSwift
import RxCocoa
import DifferenceKit

//MARK: - Input
protocol MovieDetailInputType {
    var willAppear: Observable<Bool> { get }
}

struct MovieDetailInput: MovieDetailInputType {
    var willAppear: Observable<Bool>
}

//MARK: - Output
protocol MovieDetailOutputType {
    var favoriteActionTrigger: AnyObserver<Void> { get }
    var data: Driver<MovieDataType> { get }
}

struct MovieDetailOutput: MovieDetailOutputType {
    var favoriteActionTrigger: AnyObserver<Void>
    var data: Driver<MovieDataType>
}

//MARK: - Model Type
protocol MovieDetailViewModelType: ViewModelType {
    var output: MovieDetailOutputType? { get }
    
    func transform(input: MovieDetailInputType)
}
