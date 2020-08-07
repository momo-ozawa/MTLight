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

class TransactionsViewModel {
    
    private let disposeBag = DisposeBag()

    let transactions: Driver<[Transaction]>
    let transactionsError: Observable<MTError>
    
    init(
        transactionId: Int,
        service: MTServiceProtocol
    ) {
        
        let result = service
            .getTransactions(id: transactionId)
            .materialize()
            .share(replay: 1)
        
        transactions = result
            .compactMap { $0.element }
            .map { $0.transactions }
            .asDriver(onErrorJustReturn: [])

        transactionsError = result
            .compactMap { $0.error as? MTError }
            .observeOn(MainScheduler.instance)

    }
}
