//
//  HomeHeaderViewModel.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 13/09/2022.
//

import Foundation
import RxCocoa

protocol HomeHeaderViewModelType {
    var lastVisitedDateString: Driver<String> { get set }
}

class HomeHeaderViewModel: HomeHeaderViewModelType {
    var lastVisitedDateString: Driver<String>

    init(with data: HomeOutputType) {
        self.lastVisitedDateString = data.lastVisitedDate.compactMap { $0 }
    }
}
