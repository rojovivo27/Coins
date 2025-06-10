//
//  CoinCellView.swift
//  Coins
//
//  Created by Demo on 09/06/25.
//

import SwiftUI

struct CoinCellView: View {
    let coin: CoinModel

    var body: some View {
        HStack(spacing: 16) {
            
            AsyncImage(url: URL(string: coin.image)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 48, height: 48)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 48, height: 48)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 48, height: 48)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(coin.name)
                        .font(.headline)
                    Text("(\(coin.symbol.uppercased()))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Text("$\(coin.currentPrice, specifier: "%.2f")")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)

                Text("Updated: \(formattedDate(coin.lastUpdated))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }

    func formattedDate(_ isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = formatter.date(from: isoString) else {
            return "N/A"
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        outputFormatter.timeStyle = .short

        return outputFormatter.string(from: date)
    }
}


#Preview {
    let viewModel = CoinsListViewModel()
    CoinCellView(coin: viewModel.getTestCoin())
}
