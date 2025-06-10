//
//  CoinModelTests.swift
//  CoinsTests
//
//  Created by Demo on 09/06/25.
//

import Testing
import Foundation

struct CoinModelTests {

    @Test func testCoinElementDecodesCorrectly() throws {
        let json = """
        {
            "id": "bitcoin",
            "symbol": "btc",
            "name": "Bitcoin",
            "image": "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
            "current_price": 108733,
            "market_cap": 2161127870545,
            "market_cap_rank": 1,
            "fully_diluted_valuation": 2161127870545,
            "total_volume": 31539061182,
            "high_24h": 108750,
            "low_24h": 105426,
            "price_change_24h": 2515.2,
            "price_change_percentage_24h": 2.36796,
            "market_cap_change_24h": 48727288716,
            "market_cap_change_percentage_24h": 2.30673,
            "circulating_supply": 19876609,
            "total_supply": 19876609,
            "max_supply": 21000000,
            "ath": 111814,
            "ath_change_percentage": -2.74004,
            "ath_date": "2025-05-22T18:41:28.492Z",
            "atl": 67.81,
            "atl_change_percentage": 160277.55222,
            "atl_date": "2013-07-06T00:00:00.000Z",
            "roi": {
                "times": 250.0,
                "currency": "usd",
                "percentage": 25000.0
            },
            "last_updated": "2025-06-09T20:59:41.099Z"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let coin = try decoder.decode(CoinModel.self, from: json)

        #expect(coin.id == "bitcoin")
        #expect(coin.symbol == "btc")
        #expect(coin.currentPrice == 108733)
        #expect(coin.roi?.currency == "usd")
    }

    @Test func testCoinElementHandlesNilValues() throws {
        let json = """
        {
            "id": "litecoin",
            "symbol": "ltc",
            "name": "Litecoin",
            "image": "https://assets.coingecko.com/coins/images/2/large/litecoin.png",
            "current_price": 100.0,
            "market_cap": 7000000000,
            "market_cap_rank": 15,
            "fully_diluted_valuation": 8000000000,
            "total_volume": 500000000,
            "high_24h": 105.0,
            "low_24h": 98.0,
            "price_change_24h": -1.0,
            "price_change_percentage_24h": -0.99,
            "market_cap_change_24h": -50000000,
            "market_cap_change_percentage_24h": -0.71,
            "circulating_supply": 70000000.0,
            "total_supply": 84000000.0,
            "max_supply": null,
            "ath": 410.0,
            "ath_change_percentage": -75.6,
            "ath_date": "2021-05-10T00:00:00.000Z",
            "atl": 1.15,
            "atl_change_percentage": 8600.0,
            "atl_date": "2015-01-14T00:00:00.000Z",
            "roi": null,
            "last_updated": "2025-06-09T12:30:00.000Z"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let coin = try decoder.decode(CoinModel.self, from: json)

        #expect(coin.name == "Litecoin")
        #expect(coin.maxSupply == nil)
        #expect(coin.roi == nil)
    }
}
