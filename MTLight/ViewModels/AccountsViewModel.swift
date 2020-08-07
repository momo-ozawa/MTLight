//
//  AccountsViewModel.swift
//  MTLight
//
//  Created by Momo Ozawa on 2020/08/07.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AccountsViewModel {
        
    let accounts: Driver<[Account]>
    let accountsError: Observable<MTError>
    
    private let disposeBag = DisposeBag()

    
    init(service: MTServiceProtocol) {
        
        let result = service
            .getAccounts()
            .materialize()
            .observeOn(MainScheduler.instance)
            .share(replay: 1)
        
        accounts = result
            .compactMap { $0.element }
            .map { $0.accounts }
            .asDriver(onErrorJustReturn: [])

        accountsError = result
            .compactMap { $0.error as? MTError }

    }
    
}
