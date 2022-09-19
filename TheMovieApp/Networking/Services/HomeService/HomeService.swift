//
//  HomeService.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 19/03/2022.
//

import UIKit
import RxSwift

protocol HomeServiceType {
    func search(term: String) -> Single<MovieListModel>
}

class HomeService: HomeServiceType, NetworkingType {
    
    let provider: ApiProvider<HomeAPI>
    
    init() {
        provider = ApiProvider(plugins: HomeService.plugins)
    }
    
    func search(term: String) -> Single<MovieListModel> {
        return provider.requestObject(.search(term: term), type: MovieListModel.self)
    }
    
}

