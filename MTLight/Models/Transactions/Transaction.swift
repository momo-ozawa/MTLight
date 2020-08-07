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
    let date: String
    let description: String
    let id: Int
}
