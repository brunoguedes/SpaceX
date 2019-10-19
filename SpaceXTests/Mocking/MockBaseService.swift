//
//  MockBaseService.swift
//  SpaceXTests
//
//  Created by Bruno Guedes on 19/10/19.
//  Copyright © 2019 Bruno Guedes. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
@testable import SpaceX

class MockBaseService: BaseServiceProtocol {
    enum MockResponses {
        case empty
        case launches
        case launchDetails
        case rocketDetails
    }
    
    public var mockResponse: MockResponses = .empty
    
    private var filename: String  {
        switch mockResponse {
        case .empty:
            return "ValidEmptyResponse"
        case .launches:
            return "AllLaunches"
        case .launchDetails:
            return "LaunchDetails"
        case .rocketDetails:
            return "RocketDetails"
        }
    }
    
    func data(request: URLRequest) -> Observable<Data> {
        return Observable.create { [weak self] observer in
            guard let this = self else {
                observer.onError(BaseServiceError.invalidJSON)
                return Disposables.create()
            }
            let path = Bundle(for: type(of: this)).path(forResource: this.filename, ofType: "json")
            guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped) else {
                observer.onError(BaseServiceError.invalidJSON)
                return Disposables.create()
            }
            observer.onNext(jsonData)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
