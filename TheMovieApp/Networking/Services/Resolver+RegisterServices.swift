//
//  Resolver+RegisterServices.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 17/03/2022.
//

import Resolver

extension Resolver: ResolverRegistering {
    static let services = Resolver.root
    
    public static func registerAllServices() {
        Resolver.services.register { HomeService() as HomeServiceType }.scope(.application)
        Resolver.services.register { MovieDetailService() as MovieDetailServiceType }.scope(.application)
        Resolver.services.register { DataPersistenceService() as DataPersistenceServiceType }.scope(.application)
    }
}
