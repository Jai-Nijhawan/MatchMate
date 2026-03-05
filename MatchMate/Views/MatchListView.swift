//
//  MatchListView.swift
//  MatchMate
//
//  Created by Jai Nijhawan on 05/03/26.
//

import SwiftUI
import SwiftData

struct MatchListView: View {
    @StateObject private var viewModel: MatchListViewModel
    @Environment(\.modelContext) private var modelContext
    
    init() {
        _viewModel = StateObject(wrappedValue: MatchListViewModel(
            networkService: NetworkService(),
            networkMonitor: NetworkMonitor.shared
        ))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading matches...")
                } else if let error = viewModel.errorMessage, viewModel.cardViewModels.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "wifi.slash")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        Text(error)
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.cardViewModels) { cardViewModel in
                                MatchCardView(viewModel: cardViewModel)
                            }
                        }
                        .padding()
                    }
                }
                
                if viewModel.isOffline {
                    VStack {
                        offlineBanner
                        Spacer()
                    }
                }
            }
            .navigationTitle("MatchMate")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            viewModel.setModelContext(modelContext)
            viewModel.loadProfiles()
        }
    }
    
    private var offlineBanner: some View {
        HStack {
            Image(systemName: "wifi.slash")
            Text("You are offline")
                .font(.subheadline.weight(.medium))
            Spacer()
        }
        .foregroundColor(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.orange)
    }
}
