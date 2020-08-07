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
import RxDataSources

typealias AccountSection = SectionModel<String, Account>

class AccountsViewModel {
        
    let accounts: Driver<[AccountSection]>
    let accountsError: Observable<MTError>
    
    private let disposeBag = DisposeBag()

    
    init(
        accountSelected: Signal<Account>,
        service: MTServiceProtocol,
        wireframe: AccountsWireframeProtocol
    ) {
        
        let result = service
            .getAccounts()
            .materialize()
            .share(replay: 1)
        
        accounts = result
            .compactMap { $0.element }
            .map {
                let accounts = $0.accounts
                let dictionary = Dictionary(grouping: accounts, by: { $0.institution })
                let sections = dictionary.map { AccountSection(model: $0.key, items: $0.value) }
                return sections
            }
            .asDriver(onErrorJustReturn: [])

        accountsError = result
            .compactMap { $0.error as? MTError }
            .observeOn(MainScheduler.instance)
        
        accountSelected
            .emit(onNext: { account in
                wireframe.routeToTransactions(with: account.id)
            })
            .disposed(by: disposeBag)

    }
    
}
