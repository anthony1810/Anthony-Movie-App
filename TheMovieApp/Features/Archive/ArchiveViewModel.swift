//
//  ArchiveViewModel.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 14/09/2022.
//

import UIKit
import RxSwift
import RxCocoa
import Resolver
import DifferenceKit
import XCoordinator
import Action

class ArchiveViewModel: ViewModel, ArchiveViewModelType {
    
    typealias Section = ArchiveOutputType.Section
    
    @LazyInjected(container: .services)
    private var persistenceService: DataPersistenceServiceType
    
    // MARK: - Private properties
    private let data = BehaviorRelay<Section>(value: ArraySection(model: "ArchiveList", elements:[]))
    private let router: UnownedRouter<AppRoute>
    
    // MARK: - Pulic properties
    var output: ArchiveOutputType?
    
    // MARK: Initialization
    init(router: UnownedRouter<AppRoute>) {
        self.router = router
    }
    
    func transform(input: ArchiveInputType) {
        input.willAppear
            .map { [weak self] _ -> [MovieDataView] in
                guard let `self` = self else { return [] }
                return self.persistenceService.loadMovies()
            }
            .map { [weak self] movies -> Section in
                guard let `self` = self else { return ArraySection(model: "ArchiveList", elements:[]) }
                return self.convertToSection(from: movies)
            }
            .bind(to: self.data)
            .disposed(by: rx.disposeBag)
        
        input.willDisappear
            .map { [weak self] _ in
                guard let `self` = self else { return }
                self.persistenceService.saveLastVisitedRoute(AppRoute.home)
            }
            .subscribe()
            .disposed(by: rx.disposeBag)
        
        self.persistenceService.saveLastVisitedRoute(AppRoute.archive)
        self.output = ArchiveOutput(reloadContent: data.asDriver(), itemDetailTrigger: itemDetailAction.inputs)
    }
    
    //MARK: - Private functions
    private func convertToSection(from data: [MovieDataView]) -> Section {
        return ArraySection(model: "ArchiveList", elements: data)
    }
    
    private lazy var itemDetailAction = Action<MovieDataView, Void> { [unowned self] item in
        return self.router.rx.trigger(.detail(movie: item))
    }
    
}
