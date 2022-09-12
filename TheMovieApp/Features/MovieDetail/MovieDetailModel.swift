//
//  MovieDetailModel.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 11/09/2022.
//

import RxCocoa
import RxSwift
import Resolver
import XCoordinator
import Action
import DifferenceKit
import ObjectMapper

class MovieDetailViewModel: ViewModel, MovieDetailViewModelType {
    
    var output: MovieDetailOutputType?
    private let router: UnownedRouter<AppRoute>
    private var data = BehaviorRelay<MovieDataType>(value: MovieDataView())
    
    // MARK: Initialization
    init(router: UnownedRouter<AppRoute>, movie: MovieDataType) {
        self.router = router
        self.data.accept(movie)
    }
    
    // MARK: Transform
    func transform(input: MovieDetailInputType) {
        Observable.merge(input.willAppear.mapToVoid())
            .bind(to: requestFavoriteStatus.inputs)
            .disposed(by: rx.disposeBag)
        
        requestFavoriteStatus.elements
            .filterNil()
            .bind(to: data)
            .disposed(by: rx.disposeBag)
        
        self.output = MovieDetailOutput(favoriteActionTrigger: favoriteAction.inputs, data: data.asDriver())
    }
    
    //MARK: - ACTION
    private lazy var favoriteAction = Action<Void, Bool> { [unowned self] in
       
        return .just(true)
    }
    
    private lazy var requestFavoriteStatus = Action<Void, MovieDataType?> { [unowned self] _ in
        return .just(nil)
    }
}
