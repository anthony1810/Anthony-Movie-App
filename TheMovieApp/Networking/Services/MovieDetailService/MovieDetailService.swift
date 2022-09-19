//
//  MovieDetailService.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 23/03/2022.
//

import UIKit
import RxSwift

protocol MovieDetailServiceType {
   
}

class MovieDetailService: MovieDetailServiceType, NetworkingType {
    
    let provider: ApiProvider<MovieDetailAPI>
    
    init() {
        provider = ApiProvider(plugins: MovieDetailService.plugins)
    }
    
}
