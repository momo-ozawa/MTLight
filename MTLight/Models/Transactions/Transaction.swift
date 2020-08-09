//
//  Transaction.swift
//  MTLight
//
//  Created by Momo Ozawa on 2020/08/08.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import Foundation

struct Transaction: Decodable {
    let accountId: Int
    let amount: Double
    let categoryId: Int
    let date: Date
    let description: String
    let id: Int
    
    var monthAndYear: Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .year], from: date)
        return calendar.date(from: components)
    }

    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = L10n.d
        return dateFormatter.string(from: date)
    }

}

extension Transaction: Comparable {
    
    static func < (lhs: Transaction, rhs: Transaction) -> Bool {
        lhs.date < rhs.date
    }

}
