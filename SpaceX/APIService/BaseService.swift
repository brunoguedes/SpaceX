//
//  BaseService.swift
//  SpaceX
//
//  Created by Bruno Guedes on 19/10/19.
//  Copyright © 2019 Bruno Guedes. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum BaseServiceError: Error {
    case invalidURL
    case invalidJSON
}

protocol BaseServiceProtocol {
    func data(request: URLRequest) -> Observable<Data>
}

class BaseService: BaseServiceProtocol {
    func data(request: URLRequest) -> Observable<Data> {
        return URLSession.shared.rx.data(request: request)
    }
}
