//
//  ArchiveViewModelType.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 14/09/2022.
//

import RxSwift
import RxCocoa
import DifferenceKit


//MARK: - Input
protocol ArchiveInputType {
    var willAppear: Observable<Bool> { get }
    var willDisappear: Observable<Bool> { get }
}

struct ArchiveInput: ArchiveInputType {
    var willAppear: Observable<Bool>
    var willDisappear: Observable<Bool>
}

//MARK: - Output
protocol ArchiveOutputType {
    typealias Section = ArraySection<String, MovieDataView>
    var reloadContent: Driver<Section> { get }
    var itemDetailTrigger: AnyObserver<MovieDataView> { get }
}

struct ArchiveOutput: ArchiveOutputType {
    typealias Section = ArraySection<String, MovieDataView>
    var reloadContent: Driver<Section>
    var itemDetailTrigger: AnyObserver<MovieDataView>
}

//MARK: - ArchiveViewModelType
protocol ArchiveViewModelType: ViewModelType {
    var output: ArchiveOutputType? { get }
    func transform(input: ArchiveInputType)
}
