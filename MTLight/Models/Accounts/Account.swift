//
//  Account.swift
//  MTLight
//
//  Created by Momo Ozawa on 2020/08/08.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import Foundation

struct Account: Decodable {
    let id: Int
    let nickname: String
    let institution: String
    let currency: String
    let currentBalance: Double
    let currentBalanceInBase: Double
    
    var formattedCurrentBalance: String {
        return currentBalance.toLocaleCurrency(currencyCode: currency)
    }
}

extension Account: Comparable {
    
    static func < (lhs: Account, rhs: Account) -> Bool {
        lhs.nickname.localizedCompare(rhs.nickname) == .orderedAscending
    }
    
}

