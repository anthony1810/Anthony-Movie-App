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

class HomeViewModel: ViewModel, HomeViewModelType {
    typealias Section = HomeOutputType.Section
    
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
    
    func transform(input: HomeInputType) {
        
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
    
    private lazy var itemDetailAction = Action<MovieDataView, Void> { [unowned self] item in
        return self.router.rx.trigger(.detail(movie: item))
    }
    
    private lazy var archiveButtonAction = CocoaAction { [unowned self] item in
        return self.router.rx.trigger(.archive)
    }
}

extension HomeViewModel {
    func search(term: String) -> Observable<MovieListModel> {
        return apiService.search(term: term)
            .trackActivity(self.loading)
            .trackError(self.error)
            .catchErrorJustReturn(MovieListModel())
    }
}
