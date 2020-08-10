//
//  TransactionsViewModelTests.swift
//  MTLightTests
//
//  Created by Momo Ozawa on 2020/08/09.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import MTLight

final class TransactionsViewModelTests: XCTestCase {

    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    var viewModel: TransactionsViewModel!
    
    override func setUp() {
        super.setUp()
        
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
        
        // Setup mock service with test transaction
        let service = MockMTService(
            getTransactionsMock: { _ in
                return Transactions(transactions: [Seeds.Transactions.testTransaction])
            }
        )
        
        // Setup view model
        self.viewModel = TransactionsViewModel(
            accountId: 10,
            service: service,
            wireframe: MockTransactionsWireframe()
        )
    }
    
    func testTransactions() {
        let observer = scheduler.createObserver([TransactionSection].self)
        
        let transactionsExpectation = expectation(description: #function)
        
        viewModel.transactions
            .drive(observer)
            .disposed(by: disposeBag)
        
        viewModel.transactions
            .drive(onCompleted: {
                transactionsExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let section = Seeds.Transactions.getSection(from: Seeds.Transactions.testTransaction)
        let expected = Recorded.next(0, [section])
        
        waitForExpectations(timeout: 1.0) { error in
            XCTAssertNil(error, "Error: \(error!.localizedDescription)")
            XCTAssertEqual(observer.events.first, expected)
        }
    }

}
