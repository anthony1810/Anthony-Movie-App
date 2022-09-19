//
//  ViewModelType.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 19/03/2022.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import Resolver

protocol ViewModelType {
    var loading: ActivityIndicator { get }
    var error: ErrorTracker { get }
}

class ViewModel: NSObject, ViewModelType {
    
    var loading = ActivityIndicator()
    var error = ErrorTracker()
    
    
    override init() {
        super.init()
    }
    
    deinit {
        logDebug("\(type(of: self)): Deinited")
    }
}
