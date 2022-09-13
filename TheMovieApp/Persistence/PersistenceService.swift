//
//  PersistenceService.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 12/09/2022.
//

import Foundation
import UIKit
import Resolver
import XCoordinator

protocol DataPersistenceServiceType {
    func saveMovie(_ movie: MovieDataView, artworkData: Data)
    func loadMovie(id: Int) -> MovieDataView?
    
    func saveLastVisitedTime()
    func lastVisitedTime() -> String?
    
    func saveLastVisitedRoute(_ route: AppRoute)
    func loadLastVisitedRoute() -> AppRoute?
}

class DataPersistenceService: DataPersistenceServiceType {
    
    //MARK: - Movie Data
     func saveMovie(_ movie: MovieDataView, artworkData: Data) {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError("Can't find path data") }
        do {
            let newMovie = movie
//            newMovie.artworkData = artworkData
            let encodedData = try JSONEncoder().encode(newMovie)
            let url = path.appendingPathComponent("\(movie.id.orZero)")
            try encodedData.write(to: url, options: .atomicWrite)
        } catch {
            fatalError("Can't save data because \(error.localizedDescription)")
        }
        
    }
    
     func loadMovie(id: Int) -> MovieDataView? {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError("Can't find path data") }
        do {
            let url = path.appendingPathComponent("\(id)")
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(MovieDataView.self, from: data)
            
            return decoded
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    //MARK: - Last Visited Time Data
    func saveLastVisitedTime() {
        UserDefaults.standard.set(Date().toString(), forKey: Constants.UserDefaultKeys.lastVisitedDateString)
    }
    
    func lastVisitedTime() -> String? {
        UserDefaults.standard.string(forKey: Constants.UserDefaultKeys.lastVisitedDateString)
    }
    
    //MARK:- Last Visited Route
    func saveLastVisitedRoute(_ route: AppRoute) {
        switch route {
        case .home:
            UserDefaults.standard.set(RouteModel(name: "home"), forKey: Constants.UserDefaultKeys.lastVisitedRoute)
        case .detail(let movie):
            guard let movie = movie as? MovieDataView else { return }
            UserDefaults.standard.set(RouteModel(name: "detail", movie: movie), forKey: Constants.UserDefaultKeys.lastVisitedRoute)
        default: break
        }
    }
    
    func loadLastVisitedRoute() -> AppRoute? {
        guard let result = UserDefaults.standard.value(forKey: Constants.UserDefaultKeys.lastVisitedRoute) as? RouteModel else {
            return nil
        }
        
        switch result.name {
        case "home":
            return AppRoute.home
        case "detail":
            guard let movie = result.movie else { return nil }
            return AppRoute.detail(movie: movie)
        default: return nil
        }
    }
    
}
