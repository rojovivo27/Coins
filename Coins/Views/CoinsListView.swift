//
//  ContentView.swift
//  Coins
//
//  Created by Demo on 09/06/25.
//

import SwiftUI

struct CoinsListView: View {
    @StateObject var viewModel = CoinsListViewModel()
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(2)
            } else {
                NavigationView {
                    List(viewModel.filteredCoins, id: \.id) { coin in
                        CoinCellView(coin: coin)
                    }
                    .navigationTitle("Coins")
                    .searchable(text: $viewModel.searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search coins") {
                        
                    }
                    .toolbar {
                        Button("Update") {
                            Task {
                                await viewModel.fetchCoins()
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchCoins()
            }
        }
        .alert("Error", isPresented: $viewModel.showError, actions: {}, message: {} )
    }
}

#Preview {
    CoinsListView()
}
