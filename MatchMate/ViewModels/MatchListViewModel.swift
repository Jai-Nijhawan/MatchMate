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

@MainActor
final class MatchListViewModel: ObservableObject {
    @Published var cardViewModels: [MatchCardViewModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isOffline: Bool = false
    
    private let networkService: NetworkServiceProtocol
    private let networkMonitor: NetworkMonitor
    private var modelContext: ModelContext?
    private var cancellables = Set<AnyCancellable>()
    
    init(networkService: NetworkServiceProtocol,
         networkMonitor: NetworkMonitor) {
        self.networkService = networkService
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
            errorMessage = "Database not available"
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
                let users = try await networkService.fetchUsers()
                
                for user in users {
                    let existingProfile = try fetchProfile(by: user.id, context: modelContext)
                    
                    if let existing = existingProfile {
                        existing.name = user.name
                        existing.username = user.username
                        existing.email = user.email
                        existing.phone = user.phone
                        existing.city = user.address.city
                        existing.companyName = user.company.name
                        existing.lastUpdated = Date()
                    } else {
                        let newProfile = MatchProfile.from(userModel: user)
                        modelContext.insert(newProfile)
                    }
                }
                
                try modelContext.save()
                mapToCardViewModels(modelContext: modelContext)
                isLoading = false
            } catch {
                isLoading = false
                loadFromCache(modelContext: modelContext)
            }
        }
    }
    
    private func fetchProfile(by id: Int, context: ModelContext) throws -> MatchProfile? {
        let descriptor = FetchDescriptor<MatchProfile>(
            predicate: #Predicate { $0.id == id }
        )
        return try context.fetch(descriptor).first
    }
    
    private func loadFromCache(modelContext: ModelContext) {
        do {
            let descriptor = FetchDescriptor<MatchProfile>(
                sortBy: [SortDescriptor(\.id)]
            )
            let profiles = try modelContext.fetch(descriptor)
            
            if profiles.isEmpty {
                errorMessage = "No internet connection and no cached data available"
            }
            
            mapProfilesToViewModels(profiles: profiles, modelContext: modelContext)
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "Failed to load cached data: \(error.localizedDescription)"
        }
    }
    
    private func mapToCardViewModels(modelContext: ModelContext) {
        do {
            let descriptor = FetchDescriptor<MatchProfile>(
                sortBy: [SortDescriptor(\.id)]
            )
            let profiles = try modelContext.fetch(descriptor)
            mapProfilesToViewModels(profiles: profiles, modelContext: modelContext)
        } catch {
            errorMessage = "Failed to fetch profiles"
        }
    }
    
    private func mapProfilesToViewModels(profiles: [MatchProfile], modelContext: ModelContext) {
        cardViewModels = profiles.map { profile in
            MatchCardViewModel(
                id: profile.id,
                name: profile.name,
                username: "@\(profile.username)",
                email: profile.email,
                phone: profile.phone,
                city: profile.city,
                companyName: profile.companyName,
                profileImageURL: profile.profileImageURL,
                status: profile.status,
                onAccept: { [weak self] in
                    self?.acceptMatch(id: profile.id, context: modelContext)
                },
                onDecline: { [weak self] in
                    self?.declineMatch(id: profile.id, context: modelContext)
                }
            )
        }
    }
    
    func acceptMatch(id: Int, context: ModelContext) {
        updateStatus(id: id, status: .accepted, context: context)
    }
    
    func declineMatch(id: Int, context: ModelContext) {
        updateStatus(id: id, status: .declined, context: context)
    }
    
    private func updateStatus(id: Int, status: MatchStatus, context: ModelContext) {
        do {
            let profile = try fetchProfile(by: id, context: context)
            profile?.status = status
            profile?.lastUpdated = Date()
            try context.save()
            
            if let index = cardViewModels.firstIndex(where: { $0.id == id }) {
                let profile = try fetchProfile(by: id, context: context)
                if let profile = profile {
                    cardViewModels[index] = MatchCardViewModel(
                        id: profile.id,
                        name: profile.name,
                        username: "@\(profile.username)",
                        email: profile.email,
                        phone: profile.phone,
                        city: profile.city,
                        companyName: profile.companyName,
                        profileImageURL: profile.profileImageURL,
                        status: profile.status,
                        onAccept: { [weak self] in
                            self?.acceptMatch(id: profile.id, context: context)
                        },
                        onDecline: { [weak self] in
                            self?.declineMatch(id: profile.id, context: context)
                        }
                    )
                }
            }
        } catch {
            errorMessage = "Failed to update status"
        }
    }
}
