//
//  Double+Currency.swift
//  MTLight
//
//  Created by Momo Ozawa on 2020/08/08.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import Foundation

extension Double {
    
    func toLocaleCurrency(currencyCode: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = currencyCode
        formatter.currencyCode = currencyCode
        let formattedString = formatter.string(from: self as NSNumber)
        return formattedString ?? ""
    }
}
