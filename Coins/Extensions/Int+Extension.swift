//
//  Int+Extension.swift
//  Coins
//
//  Created by Demo on 16/06/25.
//

import Foundation

extension Int {
    func formattedWithSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
