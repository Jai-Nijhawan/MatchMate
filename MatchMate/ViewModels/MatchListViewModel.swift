//
//  MatchListViewModel.swift
//  MatchMate
//
//  Created by Jai Nijhawan on 05/03/26.
//

import Foundation
import SwiftUI
import SwiftData
import Combine

enum MatchErrorMessage {
    static let databaseUnavailable = "Database not available"
    static let noCachedData = "No internet connection and no cached data available"
    static let failedToLoadCache = "Failed to load cached data"
    static let failedToUpdateStatus = "Failed to update status"
}

@MainActor
final class MatchListViewModel: ObservableObject {
    @Published var cardViewModels: [MatchCardViewModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isOffline: Bool = false
    
    private let userService: UserServiceProtocol
    private let networkMonitor: NetworkMonitor
    private var modelContext: ModelContext?
    private var cancellables = Set<AnyCancellable>()
    
    init(userService: UserServiceProtocol, networkMonitor: NetworkMonitor) {
        self.userService = userService
        self.networkMonitor = networkMonitor
        
        setupNetworkMonitoring()
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    private func setupNetworkMonitoring() {
        networkMonitor.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                self?.isOffline = !isConnected
            }
            .store(in: &cancellables)
    }
    
    func loadProfiles() {
        guard let modelContext = modelContext else {
            errorMessage = MatchErrorMessage.databaseUnavailable
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        if networkMonitor.isConnected {
            fetchFromAPI(modelContext: modelContext)
        } else {
            loadFromCache(modelContext: modelContext)
        }
    }
    
    private func fetchFromAPI(modelContext: ModelContext) {
        Task {
            do {
                let users = try await userService.fetchUsers()
                try userService.saveUsers(users, context: modelContext)
                cardViewModels = userService.mapToCardViewModels(users)
                isLoading = false
            } catch {
                isLoading = false
                loadFromCache(modelContext: modelContext)
            }
        }
    }
    
    private func loadFromCache(modelContext: ModelContext) {
        do {
            cardViewModels = try userService.fetchProfiles(context: modelContext)
            
            if cardViewModels.isEmpty {
                errorMessage = MatchErrorMessage.noCachedData
            }
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = MatchErrorMessage.failedToLoadCache
        }
    }
    
    func acceptMatch(id: Int) {
        updateStatus(id: id, status: .accepted)
    }
    
    func declineMatch(id: Int) {
        updateStatus(id: id, status: .declined)
    }
    
    private func updateStatus(id: Int, status: MatchStatus) {
        guard let modelContext = modelContext else { return }
        
        do {
            try userService.updateProfileStatus(id: id, status: status, context: modelContext)
            
            if let index = cardViewModels.firstIndex(where: { $0.id == id }) {
                cardViewModels[index].status = status
            }
        } catch {
            errorMessage = MatchErrorMessage.failedToUpdateStatus
        }
    }
}
