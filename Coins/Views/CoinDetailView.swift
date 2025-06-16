//
//  CoinDetailView.swift
//  Coins
//
//  Created by Demo on 16/06/25.
//

import SwiftUI

struct CoinDetailView: View {
    
    let coin: CoinModel
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Coin Image & Name
                VStack(spacing: 12) {
                    AsyncImage(url: URL(string: coin.image)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 100, height: 100)
                    }

                    Text(coin.name)
                        .font(.title)
                        .fontWeight(.bold)

                    Text(coin.symbol.uppercased())
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                // Stats Cards
                VStack(spacing: 16) {
                    DetailStatCard(title: "Total Volume", value: coin.totalVolume.formattedWithSeparator())
                    DetailStatCard(title: "Highest Price (24h)", value: coin.high24H.formattedAsCurrency())
                    DetailStatCard(title: "Lowest Price (24h)", value: coin.low24H.formattedAsCurrency())
                    DetailStatCard(
                        title: "Price Change (24h)",
                        value: coin.priceChange24H.formattedAsCurrency(6),
                        valueColor: coin.priceChange24H >= 0 ? .green : .red
                    )
                    DetailStatCard(title: "Market Cap", value: coin.marketCap.formattedWithSeparator())
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle(coin.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct DetailStatCard: View {
    let title: String
    let value: String
    var valueColor: Color = .primary

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(value)
                .font(.headline)
                .foregroundColor(valueColor)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}


#Preview {
    let viewModel = CoinsListViewModel()
    CoinDetailView(coin: viewModel.getTestCoin())
}
