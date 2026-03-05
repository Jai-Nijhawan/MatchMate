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
                                MatchCardView(viewModel: cardViewModel)
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

#Preview {
    MatchListView_Preview()
}

struct MatchListView_Preview: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.pink.opacity(0.3), Color.purple.opacity(0.2), Color.blue.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: 20) {
                    MatchCardView(
                        viewModel: MatchCardViewModel(
                            id: 1,
                            name: "Leanne Graham",
                            username: "Bret",
                            email: "Sincere@april.biz",
                            phone: "1-770-736-8031",
                            city: "Gwenborough",
                            companyName: "Romaguera-Crona",
                            profileImageURL: "https://i.pravatar.cc/300?u=1",
                            status: .pending,
                            onAccept: {},
                            onDecline: {}
                        )
                    )
                    
                    MatchCardView(
                        viewModel: MatchCardViewModel(
                            id: 2,
                            name: "Ervin Howell",
                            username: "Antonette",
                            email: "Shanna@melissa.tv",
                            phone: "010-692-6593",
                            city: "Wisokyburgh",
                            companyName: "Deckow-Crist",
                            profileImageURL: "https://i.pravatar.cc/300?u=2",
                            status: .accepted,
                            onAccept: {},
                            onDecline: {}
                        )
                    )
                    
                    MatchCardView(
                        viewModel: MatchCardViewModel(
                            id: 3,
                            name: "Clementine Bauch",
                            username: "Samantha",
                            email: "Nathan@yesenia.net",
                            phone: "1-463-123-4447",
                            city: "McKenziehaven",
                            companyName: "Romaguera-Jacobson",
                            profileImageURL: "https://i.pravatar.cc/300?u=3",
                            status: .declined,
                            onAccept: {},
                            onDecline: {}
                        )
                    )
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
        }
    }
}
