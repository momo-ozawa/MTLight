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
        
        let accountSelectedTap: Signal<Account> = scheduler.createColdObservable([
            Recorded.next(10, Seeds.Accounts.testAccount)
        ]).asSignal(onErrorJustReturn: Seeds.Accounts.testAccount)
        
        let service = MockMTService(
            getAccountsMock: {
                return Accounts(accounts: [Seeds.Accounts.testAccount])
            }
        )
        
        self.viewModel = AccountsViewModel(
            accountSelectedTap: accountSelectedTap,
            service: service,
            wireframe: MockAccountsWireframe()
        )
    }
    
    func testTotalBalance() {
        let totalBalanceObserver = scheduler.createObserver(String.self)

        viewModel.totalBalance
            .asObservable()
            .subscribe(totalBalanceObserver)
            .disposed(by: disposeBag)
        
        scheduler.start()
                
        XCTAssertEqual(totalBalanceObserver.events.first, Recorded.next(0, "JPY\u{00a0}0"))
    }
    
    func testAccounts() {
        let accountsObserver = scheduler.createObserver([AccountSection].self)

        viewModel.accounts
            .asObservable()
            .subscribe(accountsObserver)
            .disposed(by: disposeBag)

        scheduler.start()

        let section = Seeds.Accounts.getSection(from: Seeds.Accounts.testAccount)
        
        XCTAssertEqual(accountsObserver.events.first, Recorded.next(0, [section]))
    }

}
