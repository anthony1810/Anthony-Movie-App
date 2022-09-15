//
//  RouteModel.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 13/09/2022.
//

import Foundation
import XCoordinator


/// Represent AppRoute from XCoordinator to be saved locally for last screen open feature
struct RouteModel: Codable {
    var name: String
    var movie: MovieDataView?
}
