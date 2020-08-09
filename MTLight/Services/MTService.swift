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
    func getTransactions(id: Int) -> Observable<Transactions>
}

enum MTError: Error {
    case pathError
    case decodeError
    
    var message: String {
        switch self {
        case .pathError:
            return L10n.incorrectPathErrorOccurred
        case .decodeError:
            return L10n.decodingErrorOccurred
        }
    }
}

class MTService: MTServiceProtocol {
    
    static let shared = MTService()

    private init() {}
    
    func getAccounts() -> Observable<Accounts> {
        return loadJSON(forResource: "accounts")
    }
    
    func getTransactions(id: Int) -> Observable<Transactions> {
        return loadJSON(forResource: "transactions_\(id)")
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
                decoder.dateDecodingStrategy = .iso8601
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
