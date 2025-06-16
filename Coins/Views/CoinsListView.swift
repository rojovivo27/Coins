//
//  ContentView.swift
//  Coins
//
//  Created by Demo on 09/06/25.
//

import SwiftUI

struct CoinsListView: View {
    @StateObject var viewModel = CoinsListViewModel()
    @State private var isRefreshing = false
    @State private var pullStatus: CGFloat = 0
    @State private var hasTriggeredRefresh = false
    var body: some View {
        NavigationView {
            ScrollView {
                GeometryReader { geo in
                    Color.clear
                        .preference(key: PullToRefreshPreferenceKey.self, value: geo.frame(in: .named("pull")).midY)
                }
                .frame(height: 0)

                if isRefreshing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.top, 8)
                }

                LazyVStack(spacing: 12) {
                    ForEach(viewModel.filteredCoins, id: \.id) { coin in
                        NavigationLink(destination: CoinDetailView(coin: coin)) {
                            CoinCellView(coin: coin)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .navigationTitle("Coins")
                    .searchable(text: $viewModel.searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search coins") {}
                }
                .padding(.top)
            }
            .coordinateSpace(name: "pull") // 👈 Define custom space
            .onPreferenceChange(PullToRefreshPreferenceKey.self) { value in
                //print("Pull value: \(value)")

                if value < 10 {
                    hasTriggeredRefresh = false
                }

                if value > 80 && !isRefreshing && !hasTriggeredRefresh {
                    hasTriggeredRefresh = true
                    withAnimation {
                        isRefreshing = true
                    }
                    Task {
                        await viewModel.fetchCoinsDebounced()
                        withAnimation {
                            isRefreshing = false
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
        .alert("Error", isPresented: $viewModel.showError, actions: {}, message: {
            Text(viewModel.errorMessage ?? "")
        } )
    }
}

struct PullToRefreshPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

#Preview {
    CoinsListView()
}
