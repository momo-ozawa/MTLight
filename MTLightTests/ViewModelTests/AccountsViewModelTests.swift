//
//  AccountsViewModelTests.swift
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

final class AccountsViewModelTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    var viewModel: AccountsViewModel!
    
    override func setUp() {
        super.setUp()
        
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
        
        // Setup mock service with test account
        let service = MockMTService(
            getAccountsMock: {
                return Accounts(accounts: [Seeds.Accounts.testAccount])
            }
        )
        
        // Setup view model
        self.viewModel = AccountsViewModel(
            accountSelectedTap: Signal.never(),
            service: service,
            wireframe: MockAccountsWireframe()
        )
    }
    
    func testTotalBalance() {
        let observer = scheduler.createObserver(String.self)
        
        let totalBalanceExpectation = expectation(description: #function)

        viewModel.totalBalance
            .drive(observer)
            .disposed(by: disposeBag)
        
        viewModel.totalBalance
            .drive(onCompleted: {
                totalBalanceExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expected = Recorded.next(0, "JPY\u{00a0}0")
        
        waitForExpectations(timeout: 1.0) { error in
            XCTAssertNil(error, "Error: \(error!.localizedDescription)")
            XCTAssertEqual(observer.events.first, expected)
        }
    }
    
    func testAccounts() {
        let observer = scheduler.createObserver([AccountSection].self)

        let accountsExpectation = expectation(description: #function)

        viewModel.accounts
            .drive(observer)
            .disposed(by: disposeBag)
        
        viewModel.accounts
            .drive(onCompleted: {
                accountsExpectation.fulfill()
            })
            .disposed(by: disposeBag)

        scheduler.start()

        let section = Seeds.Accounts.getSection(from: Seeds.Accounts.testAccount)
        let expected = Recorded.next(0, [section])
        
        waitForExpectations(timeout: 1.0) { error in
            XCTAssertNil(error, "Error: \(error!.localizedDescription)")
            XCTAssertEqual(observer.events.first, expected)
        }
    }

}
