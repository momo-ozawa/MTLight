//
//  MTService.swift
//  MTLight
//
//  Created by Momo Ozawa on 2020/08/08.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import Foundation
import RxSwift

protocol MTServiceProtocol {
    func getAccounts() -> Observable<Accounts>
}

enum MTError: Error {
    case pathError
    case decodeError
    
    var message: String {
        switch self {
        case .pathError:
            return "Incorrect path error occurred"
        case .decodeError:
            return "Decoding error occurred"
        }
    }
}

class MTService: MTServiceProtocol {
    
    static let shared = MTService()

    private init() {}
    
    func getAccounts() -> Observable<Accounts> {
        return loadJSON(forResource: "accounts")
    }
    
    private func loadJSON<T>(forResource name: String) -> Observable<T> where T: Decodable {
        return Observable.create { observer in
            
            guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
                observer.onError(MTError.pathError)
                return Disposables.create()
            }

            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let jsonData = try decoder.decode(T.self, from: data)
                observer.onNext(jsonData)
                observer.onCompleted()
            } catch {
                observer.onError(MTError.decodeError)
            }
            
            return Disposables.create()
        }
    }
}
