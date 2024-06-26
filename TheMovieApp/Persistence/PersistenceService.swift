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
    func saveMovie(_ movie: MovieDataView)
    func loadMovie(id: Int) -> MovieDataView?
    func loadMovies() -> [MovieDataView]
    
    func saveLastVisitedTime()
    func lastVisitedTime() -> String?
    
    func saveLastVisitedRoute(_ route: AppRoute)
    func loadLastVisitedRoute() -> AppRoute?
}

class DataPersistenceService: DataPersistenceServiceType {
    
    //MARK: - Movie Data
    
    /// Save movie to disk for offline use
    /// - Parameter movie: Object represent movie info from Itune search API
    func saveMovie(_ movie: MovieDataView) {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError("Can't find path data") }
        do {
            let encodedData = try JSONEncoder().encode(movie)
            let url = path.appendingPathComponent("\(movie.id.orZero)")
            try encodedData.write(to: url, options: .atomicWrite)
        } catch {
            fatalError("Can't save data because \(error.localizedDescription)")
        }
        
    }
    
    
    /// Load a movie from disk, basically turn it from data to MovieDataView object
    /// - Parameter id: id of the movie
    /// - Returns: Complete MovieDataView Object
    func loadMovie(id: Int) -> MovieDataView? {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError("Can't find path data") }
        do {
            let url = path.appendingPathComponent("\(id)")
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(MovieDataView.self, from: data)
            
            return decoded
        } catch {
//            print(error.localizedDescription)
            return nil
        }
    }
    
    
    /// Load all saved movies from disk
    /// - Returns: An Array of all saved movies
    func loadMovies() -> [MovieDataView] {
        do {
            // Get the document directory url
            let documentDirectory = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(
                at: documentDirectory,
                includingPropertiesForKeys: nil
            )
            let movies = try directoryContents.map { try Data(contentsOf: $0)}.map { try JSONDecoder().decode(MovieDataView.self, from: $0)}
           
            return movies
            
        } catch {
            print(error)
            return []
        }
    }
    
    //MARK: - Last Visited Time Data
    
    
    /// Save Last time app was opened
    func saveLastVisitedTime() {
        let value = Date().toString()
        UserDefaults.standard.set(value, forKey: Constants.UserDefaultKeys.lastVisitedDateString)
    }
    
    
    /// Load from UserDefault Date String of last time app was  opened
    /// - Returns: a Date string of lat time app was opened
    func lastVisitedTime() -> String? {
        UserDefaults.standard.string(forKey: Constants.UserDefaultKeys.lastVisitedDateString)
    }
    
    //MARK: - Last Visited Route
    
    /// Save Last Screen app was open along with MovieDataView object if any for offline use
    /// - Parameter route: App Route of which Screen to be saved
    func saveLastVisitedRoute(_ route: AppRoute) {
        var lastVisitRouteData = Data()
        do {
            switch route {
            case .home:
                lastVisitRouteData = try JSONEncoder().encode(RouteModel(name: "home"))
            case .detail(let movie):
                guard let movie = movie as? MovieDataView else { return }
                lastVisitRouteData = try JSONEncoder().encode(RouteModel(name: "detail", movie: movie))
            case .archive:
                lastVisitRouteData = try JSONEncoder().encode(RouteModel(name: "archive"))
            default: break
            }
        } catch {
            print("can't encode last visit route: \(error)")
        }
        UserDefaults.standard.set(lastVisitRouteData, forKey: Constants.UserDefaultKeys.lastVisitedRoute)
    }
    
    
    /// Load last visit screen from
    /// - Returns: Last Visit App Route object to know which screen was opened and MovieDataView if any
    func loadLastVisitedRoute() -> AppRoute? {
        guard let lastRouteData = UserDefaults.standard.value(forKey: Constants.UserDefaultKeys.lastVisitedRoute) as? Data else {
            return nil
        }
        
        do {
            let result = try JSONDecoder().decode(RouteModel.self, from: lastRouteData)
            
            switch result.name {
            case "home":
                return AppRoute.home
            case "detail":
                guard let movie = result.movie else { return nil }
                return AppRoute.detail(movie: movie)
            case "archive":
                return AppRoute.archive
            default: return nil
            }
        } catch {
            print("can't decode last route data: \(error)")
        }
        
        return nil
    }
    
}
