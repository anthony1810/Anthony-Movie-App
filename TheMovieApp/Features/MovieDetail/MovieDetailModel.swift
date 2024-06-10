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
import Foundation

class MovieDetailViewModel: ViewModel, MovieDetailViewModelType {
    
    // MARK: - Public properties
    var output: MovieDetailOutputType?
    
    // MARK: - Private properties
    private let router: UnownedRouter<AppRoute>
    private var data = BehaviorRelay<MovieDataType>(value: MovieDataView())
    
    // MARK: - Services
    @LazyInjected(container: .services)
    private var persistenceService: DataPersistenceServiceType
    
    // MARK: Initialization
    init(router: UnownedRouter<AppRoute>, movie: MovieDataType) {
        self.router = router
        self.data.accept(movie)
    }
    
    // MARK: - Transform
    func transform(input: MovieDetailInputType) {
        
        input.willAppear
            .mapToVoid()
            .bind(to: requestFavoriteStatus.inputs)
            .disposed(by: rx.disposeBag)
        
        requestFavoriteStatus.elements
            .filterNil()
            .bind(to: data)
            .disposed(by: rx.disposeBag)
        
        favoriteAction
            .elements
            .filterNil()
            .bind(to: data)
            .disposed(by: rx.disposeBag)
        
        requestFavoriteStatus.elements
            .map { [weak self] _ -> MovieDataType? in
                guard let `self` = self else { return nil }
                return self.data.value
            }
            .filterNil()
            .bind(to: updateLastVisitRoute.inputs)
            .disposed(by: rx.disposeBag)
        
        input.willDisappear
            .map { [weak self] _ in
                guard let `self` = self else { return }
                self.persistenceService.saveLastVisitedRoute(AppRoute.home)
            }
            .subscribe()
            .disposed(by: rx.disposeBag)
        
        self.output = MovieDetailOutput(favoriteActionTrigger: favoriteAction.inputs, data: data.asDriver())
    }
    
    //MARK: - ACTION
    private lazy var favoriteAction = Action<Data, MovieDataType?> { [unowned self] artWorkData in
        guard var movieDataView = data.value as? MovieDataView else { return .just(nil) }
        var newMovieDataView = movieDataView.copy() as! MovieDataView
        
        newMovieDataView.isFavorite = true
        newMovieDataView.artworkData = artWorkData
        
        self.data.accept(newMovieDataView)
        persistenceService.saveMovie(newMovieDataView)
        return .just(newMovieDataView)
    }
    
    private lazy var requestFavoriteStatus = Action<Void, MovieDataType?> { [unowned self] _ in
        guard let id = data.value.id else { return .just(nil) }
        let result = persistenceService.loadMovie(id: id)
        return .just(result)
    }
    
    private lazy var updateLastVisitRoute = Action<MovieDataType, Void> {[unowned self] movie in
        return .just(self.persistenceService.saveLastVisitedRoute(AppRoute.detail(movie: movie)))
    }
}
