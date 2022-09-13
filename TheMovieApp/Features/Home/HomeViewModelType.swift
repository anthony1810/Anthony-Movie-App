//
//  HomeViewModelType.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 09/09/2022.
//

import RxSwift
import RxCocoa
import DifferenceKit

protocol HomeInputType {
    var willAppear: Observable<Bool> { get }
    var searchTextDidChange: Observable<String> { get }
}

struct HomeInput: HomeInputType {
    var willAppear: Observable<Bool>
    var searchTextDidChange: Observable<String>
}

// MARK: - Output
protocol HomeOutputType {
    typealias Section = ArraySection<String, MovieDataView>
    var reloadContent: Driver<Section> { get }
    var itemDetailTrigger: AnyObserver<MovieDataView> { get }
}

struct HomeOutput: HomeOutputType {
    
    typealias Section = ArraySection<String, MovieDataView>
    var reloadContent: Driver<Section>
    var itemDetailTrigger: AnyObserver<MovieDataView>
}

// MARK: - HomeViewModelType
protocol HomeViewModelType: ViewModelType {
    var output: HomeOutputType? { get }
    
    func transform(input: HomeInputType)
}
