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
            userService: UserService(networkService: NetworkService()),
            networkMonitor: NetworkMonitor.shared
        ))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                
                if viewModel.isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Finding your perfect match...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                } else if let error = viewModel.errorMessage, viewModel.cardViewModels.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "wifi.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        Text(error)
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.cardViewModels) { cardViewModel in
                                MatchCardView(
                                    viewModel: cardViewModel,
                                    onAccept: { viewModel.acceptMatch(id: cardViewModel.id) },
                                    onDecline: { viewModel.declineMatch(id: cardViewModel.id) }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                    }
                }
                
                VStack {
                    Spacer()
                    if viewModel.isOffline {
                        offlineBanner
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
            Text("You are offline - Cached data shown")
                .font(.subheadline.weight(.medium))
            Spacer()
        }
        .foregroundColor(.white)
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.orange)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.pink.opacity(0.3), Color.purple.opacity(0.2), Color.blue.opacity(0.1)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
