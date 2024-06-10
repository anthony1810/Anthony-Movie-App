//
//  MovieDetailModelType.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 11/09/2022.
//

import RxSwift
import RxCocoa
import DifferenceKit
import Foundation

//MARK: - Input
protocol MovieDetailInputType {
    var willAppear: Observable<Bool> { get }
    var willDisappear: Observable<Bool> { get }
}

struct MovieDetailInput: MovieDetailInputType {
    var willAppear: Observable<Bool>
    var willDisappear: Observable<Bool> 
}

//MARK: - Output
protocol MovieDetailOutputType {
    var favoriteActionTrigger: AnyObserver<Data> { get }
    var data: Driver<MovieDataType> { get }
}

struct MovieDetailOutput: MovieDetailOutputType {
    var favoriteActionTrigger: AnyObserver<Data>
    var data: Driver<MovieDataType>
}

//MARK: - Model Type
protocol MovieDetailViewModelType: ViewModelType {
    var output: MovieDetailOutputType? { get }
    
    func transform(input: MovieDetailInputType)
}
