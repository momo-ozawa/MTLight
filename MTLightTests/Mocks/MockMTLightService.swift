//
//  MockMTLightService.swift
//  MTLightTests
//
//  Created by Momo Ozawa on 2020/08/09.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import RxSwift
import XCTest
@testable import MTLight

final class MockMTService: MTServiceProtocol {
    
    private var getAccountsMock: () -> Accounts
    private var getTransactionsMock: (Int) -> Transactions
    
    init(
        getAccountsMock: @escaping () -> Accounts = { Accounts(accounts: []) },
        getTransactionsMock: @escaping (Int) -> Transactions = { _ in Transactions(transactions: []) }
    ) {
        self.getAccountsMock = getAccountsMock
        self.getTransactionsMock = getTransactionsMock
    }
    
    func getAccounts() -> Observable<Accounts> {
        return Observable.of(getAccountsMock())
    }
    
    func getTransactions(accountId: Int) -> Observable<Transactions> {
        return Observable.of(getTransactionsMock(accountId))
    }

}
