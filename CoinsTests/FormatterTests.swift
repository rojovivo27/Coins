//
//  FormatterTests.swift
//  Coins
//
//  Created by Demo on 16/06/25.
//

import Testing

@Suite struct FormatterTests {
    
    @Test func testCurrencyFormatting() {
        let value: Double = 1234.5678
        let formatted = value.formattedAsCurrency()
        #expect(formatted == "US$1,234.57")
    }
    
    @Test func testCurrencyFormatting4Digits() {
        let value: Double = 1234.5678
        let formatted = value.formattedAsCurrency(4)
        #expect(formatted == "US$1,234.5678")
    }
    
    @Test func testCurrencyFormattingNegative() {
        let value: Double = -89.99
        let formatted = value.formattedAsCurrency()
        #expect(formatted == "-US$89.99")
    }
    
    @Test func testCurrencyFormattingNegative3Digits() {
        let value: Double = -89.999
        let formatted = value.formattedAsCurrency(3)
        #expect(formatted == "-US$89.999")
    }

    @Test func testThousandSeparatorFormatting() {
        let value: Int = 1_234_567
        let formatted = value.formattedWithSeparator()
        #expect(formatted == "1,234,567")
    }

    @Test func testZeroFormatting() {
        let doubleFormatted = 0.0.formattedAsCurrency()
        let intFormatted = 0.formattedWithSeparator()

        #expect(doubleFormatted == "US$0.00")
        #expect(intFormatted == "0")
    }
}
