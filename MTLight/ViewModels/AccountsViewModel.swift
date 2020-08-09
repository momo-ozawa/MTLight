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
        
    let totalBalance: Driver<String>
    let accounts: Driver<[AccountSection]>
    let accountsError: Observable<MTError>
    
    private let disposeBag = DisposeBag()

    init(
        accountSelectedTap: Signal<Account>,
        service: MTServiceProtocol,
        wireframe: AccountsWireframeProtocol
    ) {
        
        let result = service
            .getAccounts()
            .materialize()
            .share(replay: 1)
        
        totalBalance = result
            .compactMap { $0.element }
            .map {
                let accounts = $0.accounts
                let balances = accounts.map { $0.currentBalanceInBase }
                let totalBalance = balances.reduce(0.0, +)
                return totalBalance.toLocaleCurrency(currencyCode: L10n.jpy)
            }
            .asDriver(onErrorJustReturn: 0.0.toLocaleCurrency(currencyCode: L10n.jpy))

        accounts = result
            .compactMap { $0.element }
            .map {
                let accounts = $0.accounts
                let dictionary = Dictionary(grouping: accounts, by: { $0.institution })
                let sections = dictionary.map {
                    AccountSection(model: $0.key, items: $0.value.sorted())
                }
                let sortedSections = sections.sorted { $0.model < $1.model }
                return sortedSections
            }
            .asDriver(onErrorJustReturn: [])

        accountsError = result
            .compactMap { $0.error as? MTError }
            .observeOn(MainScheduler.instance)
        
        accountSelectedTap
            .emit(onNext: { account in
                wireframe.routeToTransactions(with: account)
            })
            .disposed(by: disposeBag)

    }
    
}
