//
//  CoinsListViewModel.swift
//  Coins
//
//  Created by Demo on 09/06/25.
//

import Foundation

@MainActor
class CoinsListViewModel: ObservableObject {
    @Published var coins: [CoinModel] = []
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    @Published var searchQuery: String = ""
    
    private var lastRefreshDate: Date = .distantPast
    private let debounceInterval: TimeInterval = 1.0
    
    var filteredCoins: [CoinModel] {
        if searchQuery.isEmpty {
            return coins
        } else {
            return coins.filter {
                $0.name.localizedCaseInsensitiveContains(searchQuery) ||
                $0.symbol.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }
    
    func fetchCoinsDebounced() async {
        let now = Date()
        guard now.timeIntervalSince(lastRefreshDate) > debounceInterval else {
            print("⏳ Skipping refresh — debounce in effect")
            return
        }

        lastRefreshDate = now
        await fetchCoins()
    }
    
    func fetchCoins() async {
        isLoading = true
        errorMessage = nil
        
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd"
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response")
                isLoading = false
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ HTTP error: \(httpResponse.statusCode)")

                if let jsonString = String(data: data, encoding: .utf8) {
                    showError = true
                    errorMessage = "❌ API error response body: \(jsonString)"
                    isLoading = false
                    print(errorMessage ?? "")
                }

                return
            }
    
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedCoins = try decoder.decode([CoinModel].self, from: data)
            await MainActor.run {
                self.coins = Array(decodedCoins.prefix(20))
            }

        } catch {
            self.errorMessage = "Failed to fetch coins: \(error.localizedDescription)"
            print(errorMessage ?? "")
        }
        isLoading = false
    }
    
    func getTestCoin() -> CoinModel {
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

        return try! decoder.decode(CoinModel.self, from: json)
    }
}
