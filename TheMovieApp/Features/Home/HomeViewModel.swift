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
    
    // MARK: - Private properties
    private let data = BehaviorRelay<Section>(value: ArraySection(model: "SearchResult", elements:[]))
    private let router: UnownedRouter<AppRoute>
    
    // MARK: - Pulic properties
    var output: HomeOutputType?
    
    // MARK: Initialization
    init(router: UnownedRouter<AppRoute>) {
        self.router = router
    }
    
    func transform(input: HomeInputType) {
        input.searchTextDidChange
            .skip(1)
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .distinctUntilChanged()
            .flatMapLatest { [unowned self] keyword -> Observable<MovieListModel> in
                return self.search(term: keyword)
            }
            .map { [unowned self] result -> Section in
                return self.convertToSection(from: result)
            }
            .bind(to: self.data)
            .disposed(by: rx.disposeBag)
        
        self.output = HomeOutput(reloadContent: data.asDriver(), itemDetailTrigger: itemDetailAction.inputs)
    }
    
    //MARK: - Private functions
    private func convertToSection(from data: MovieListModel) -> Section {
        return ArraySection(model: "SearchResult", elements: data.results.orArrEmpty.compactMap { MovieDataView(input: $0)})
    }
    
    private lazy var itemDetailAction = Action<MovieDataView, Void> { [unowned self] item in
        guard let id = item.id else { return .just(()) }
        return self.router.rx.trigger(.detail(movieId: id))
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
