//
//  Seeds.swift
//  MTLightTests
//
//  Created by Momo Ozawa on 2020/08/09.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import XCTest
@testable import MTLight

enum Seeds {
    
    enum Accounts {
        static let testAccount = Account(
             id: 0,
             nickname: "Test",
             institution: "Institution",
             currency: "JPY",
             currentBalance: 0.0,
             currentBalanceInBase: 0.0
         )
        
        static func getSection(from account: Account) -> AccountSection {
            return AccountSection(model: account.institution, items: [account])
        }
    }
    
    enum Transactions {
        static let testTransaction = Transaction(
            accountId: 0,
            amount: 10.0,
            categoryId: 0,
            date: Date(timeIntervalSince1970: 0),
            description: "Description",
            id: 123
        )
        
        static func getSection(from transaction: Transaction) -> TransactionSection {
            return TransactionSection(model: transaction.monthAndYear!, items: [transaction])
        }
    }
    
}
