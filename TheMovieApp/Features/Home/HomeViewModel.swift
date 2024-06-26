//
//  HomeViewModel.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 09/09/2022.
//

import UIKit
import RxSwift
import RxCocoa
import Resolver
import DifferenceKit
import XCoordinator
import Action
import XCoordinatorRx

class HomeViewModel: ViewModel, HomeViewModelType {
    /// Data Object Representation will be used in owner view controller
    typealias Section = HomeOutputType.Section
    
    // MARK: - Services
    @LazyInjected(container: .services)
    private var apiService: HomeServiceType
    
    @LazyInjected(container: .services)
    private var persistenceService: DataPersistenceServiceType
    
    // MARK: - Private properties
    private let data = BehaviorRelay<Section>(value: ArraySection(model: "SearchResult", elements:[]))
    private let lastVisitedDate = BehaviorRelay<String?>(value: nil)
    private let router: UnownedRouter<AppRoute>
    
    
    // MARK: - Pulic properties
    var output: HomeOutputType?
    
    // MARK: Initialization
    init(router: UnownedRouter<AppRoute>) {
        self.router = router
    }
    
    // MARK: - Transform
    func transform(input: HomeInputType) {
    
        Observable.just(())
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(to: deeplinkTrigger.inputs)
            .disposed(by: rx.disposeBag)
        
        Observable.combineLatest(input.searchTextDidChange, input.willAppear)
            .map { $0.0 }
            .skip(1)
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .flatMapLatest { [unowned self] keyword -> Observable<MovieListModel> in
                return self.search(term: keyword)
            }
            .map { [unowned self] result -> Section in
                return self.convertToSection(from: result)
            }
            .map { [unowned self] in self.transformToFavorite(from: $0) }
            .bind(to: self.data)
            .disposed(by: rx.disposeBag)
        
        Observable.just(persistenceService.lastVisitedTime())
            .map { "\(R.string.localizable.homeLastvisit()) \($0 == nil ? "recently" : $0.orStringEmpty)" }
            .bind(to: lastVisitedDate)
            .disposed(by: rx.disposeBag)
        
        self.output = HomeOutput(reloadContent: data.asDriver(),
                                 itemDetailTrigger: itemDetailAction.inputs,
                                 archiveButtonTrigger: archiveButtonAction.inputs,
                                 favoriteButtonTrigger: favoriteAction.inputs,
                                 lastVisitedDate: lastVisitedDate.asDriver())
        
    }
    
    //MARK: - Private functions
    private func convertToSection(from data: MovieListModel) -> Section {
        return ArraySection(model: "SearchResult", elements: data.results.orArrEmpty.compactMap { MovieDataView(input: $0)})
    }
    
    private func transformToFavorite(from section: Section) -> Section {
        for movie in section.elements {
            guard let id = movie.id else { continue }
            if let _ = persistenceService.loadMovie(id: id) {
                movie.isFavorite = true
            }
        }
        return section
    }
    
    //MARK: - private ACTION
    private lazy var itemDetailAction = Action<MovieDataView, Void> { [unowned self] item in
        return self.router.rx.trigger(.detail(movie: item))
    }
    
    private lazy var archiveButtonAction = CocoaAction { [unowned self] item in
        return self.router.rx.trigger(.archive)
    }
    
    private lazy var deeplinkTrigger = CocoaAction { [unowned self] in
        guard let lastVisitRoute = self.persistenceService.loadLastVisitedRoute() else { return Observable.just(())}
        self.persistenceService.saveLastVisitedRoute(AppRoute.home)
        return self.router.rx.trigger(.deeplink(route: lastVisitRoute))
    }

    private lazy var favoriteAction = Action<(Int, Data), Void> { [unowned self] (movieId, imgData) in
        guard let movie = data.value.elements.filter({ $0.id == movieId }).first else { return .just(())  }
      
        movie.isFavorite = true
        movie.artworkData = imgData

        persistenceService.saveMovie(movie)
        return .just(())
    }
}

//MARK: - External Services
extension HomeViewModel {
    func search(term: String) -> Observable<MovieListModel> {
        return apiService.search(term: term)
            .trackActivity(self.loading)
            .trackError(self.error)
            .catchErrorJustReturn(MovieListModel())
    }
}
