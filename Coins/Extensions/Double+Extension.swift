//
//  Double+Extension.swift
//  Coins
//
//  Created by Demo on 16/06/25.
//

import Foundation

extension Double {
    func formattedAsCurrency(_ numberOfDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = numberOfDigits
        return formatter.string(from: NSNumber(value: self)) ?? "$0.00"
    }
    
    func formattedWithSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
