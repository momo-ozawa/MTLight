//
//  TransactionsViewModel.swift
//  MTLight
//
//  Created by Momo Ozawa on 2020/08/08.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

typealias TransactionSection = SectionModel<Date, Transaction>

class TransactionsViewModel {
    
    let transactions: Driver<[TransactionSection]>
    let transactionsError: Driver<MTError>
    
    private let disposeBag = DisposeBag()
    
    init(
        accountId: Int,
        service: MTServiceProtocol,
        wireframe: TransactionsWireframeProtocol
    ) {
        
        let result = service
            .getTransactions(accountId: accountId)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .materialize()
            .share(replay: 1)
        
        transactions = result
            .compactMap { $0.element }
            .map {
                let transactions = $0.transactions
                let dictionary = Dictionary(grouping: transactions, by: { $0.monthAndYear! })
                let sections = dictionary.map {
                    TransactionSection(model: $0.key, items: $0.value.sorted(by: >))
                }
                let sortedSections = sections.sorted { $0.model > $1.model }
                return sortedSections
            }
            .asDriver(onErrorJustReturn: [])

        transactionsError = result
            .compactMap { $0.error as? MTError }
            .asDriver(onErrorDriveWith: Driver.never())

    }
}
