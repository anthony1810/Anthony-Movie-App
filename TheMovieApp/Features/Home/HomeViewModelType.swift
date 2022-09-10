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
    var pullToRefresh: Driver<Void> { get }
    var willAppear: Observable<Bool> { get }
}

struct HomeInput: HomeInputType {
    var pullToRefresh: Driver<Void>
    var willAppear: Observable<Bool>
}

// MARK: - Output
protocol HomeOutputType {
    typealias Section = ArraySection<String, MovieDataView>
    
    var reloadCell: Driver<[Section]> { get }
    
    var loading: Observable<Bool> { get }
    
    var itemDetailTrigger: AnyObserver<Int> { get }
}

struct HomeOutput: HomeOutputType {
    
    typealias Section = ArraySection<String, MovieDataView>
    
    var reloadCell: Driver<[Section]>
  
    var loading: Observable<Bool>
    
    var itemDetailTrigger: AnyObserver<Int>
}

// MARK: - HomeViewModelType
protocol HomeViewModelType: ViewModelType {
    var output: HomeOutputType? { get }
    
    func transform(input: HomeInputType)
}
