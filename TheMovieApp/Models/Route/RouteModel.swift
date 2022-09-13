//
//  RouteModel.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 13/09/2022.
//

import Foundation
import XCoordinator

struct RouteModel: Codable {
    var name: String
    var movie: MovieDataView?
}
