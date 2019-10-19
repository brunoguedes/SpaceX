//
//  SpaceXService.swift
//  SpaceX
//
//  Created by Bruno Guedes on 19/10/19.
//  Copyright © 2019 Bruno Guedes. All rights reserved.
//

import Foundation
import RxSwift

protocol SpaceXServiceProtocol {
    func getLaunches() -> Observable<Launches>
    func getLaunchDetails(for flightNumber: Int) -> Observable<LaunchDetails>
    func getRocketDetails(for rocketId: String) -> Observable<RocketDetails>
}

class SpaceXService: SpaceXServiceProtocol {
    
    let baseService: BaseServiceProtocol
    let baseURL = URL(string: "https://api.spacexdata.com/v3/launches")
    
    init(baseService: BaseServiceProtocol = BaseService()) {
        self.baseService = baseService
    }
    
    func getLaunches() -> Observable<Launches> {
        guard let url = URL(string: "launches", relativeTo: baseURL) else {
            return Observable.create { (observer) -> Disposable in
                observer.onError(BaseServiceError.invalidURL)
                return Disposables.create()
            }
        }
        let urlRequest = URLRequest(url: url)
        return baseService.data(request: urlRequest).map { (data) -> Launches in
            do {
                let launches = try JSONDecoder().decode(Launches.self, from: data)
                return launches
            } catch {
                throw BaseServiceError.invalidJSON
            }
        }
    }
    
    func getLaunchDetails(for flightNumber: Int) -> Observable<LaunchDetails> {
        guard let url = URL(string: "launches/\(flightNumber)", relativeTo: baseURL) else {
            return Observable.create { (observer) -> Disposable in
                observer.onError(BaseServiceError.invalidURL)
                return Disposables.create()
            }
        }
        let urlRequest = URLRequest(url: url)
        return baseService.data(request: urlRequest).map { (data) -> LaunchDetails in
            do {
                let launchDetails = try JSONDecoder().decode(LaunchDetails.self, from: data)
                return launchDetails
            } catch {
                throw BaseServiceError.invalidJSON
            }
        }
    }

    func getRocketDetails(for rocketId: String) -> Observable<RocketDetails> {
        guard let url = URL(string: "rockets/\(rocketId)", relativeTo: baseURL) else {
            return Observable.create { (observer) -> Disposable in
                observer.onError(BaseServiceError.invalidURL)
                return Disposables.create()
            }
        }
        let urlRequest = URLRequest(url: url)
        return baseService.data(request: urlRequest).map { (data) -> RocketDetails in
            do {
                let rocketDetails = try JSONDecoder().decode(RocketDetails.self, from: data)
                return rocketDetails
            } catch {
                throw BaseServiceError.invalidJSON
            }
        }
    }
}
