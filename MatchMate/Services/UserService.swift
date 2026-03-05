//
//  UserService.swift
//  MatchMate
//
//  Created by Jai Nijhawan on 05/03/26.
//

import Foundation
import SwiftData

protocol UserServiceProtocol {
    func fetchUsers() async throws -> [UserModel]
    func saveUsers(_ users: [UserModel], context: ModelContext) throws
    func fetchProfiles(context: ModelContext) throws -> [MatchCardViewModel]
    func updateProfileStatus(id: Int, status: MatchStatus, context: ModelContext) throws
    func mapToCardViewModels(_ users: [UserModel]) -> [MatchCardViewModel]
}

final class UserService: UserServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let baseURL = "https://jsonplaceholder.typicode.com/users"
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchUsers() async throws -> [UserModel] {
        try await networkService.request(baseURL)
    }
    
    func saveUsers(_ users: [UserModel], context: ModelContext) throws {
        for user in users {
            let descriptor = FetchDescriptor<MatchProfile>(
                predicate: #Predicate { $0.id == user.id }
            )
            let existing = try context.fetch(descriptor).first
            
            if let existing = existing {
                existing.name = user.name
                existing.username = user.username
                existing.email = user.email
                existing.phone = user.phone
                existing.city = user.address.city
                existing.companyName = user.company.name
            } else {
                let newProfile = MatchProfile.from(userModel: user)
                context.insert(newProfile)
            }
        }
        try context.save()
    }
    
    func fetchProfiles(context: ModelContext) throws -> [MatchCardViewModel] {
        let descriptor = FetchDescriptor<MatchProfile>(
            sortBy: [SortDescriptor(\.id)]
        )
        let profiles = try context.fetch(descriptor)
        return profiles.map { profile in
            MatchCardViewModel(
                id: profile.id,
                name: profile.name,
                username: "@\(profile.username)",
                email: profile.email,
                phone: profile.phone,
                city: profile.city,
                companyName: profile.companyName,
                profileImageURL: profile.profileImageURL,
                status: profile.status
            )
        }
    }
    
    func updateProfileStatus(id: Int, status: MatchStatus, context: ModelContext) throws {
        let descriptor = FetchDescriptor<MatchProfile>(
            predicate: #Predicate { $0.id == id }
        )
        if let profile = try context.fetch(descriptor).first {
            profile.status = status
            try context.save()
        }
    }
    
    func mapToCardViewModels(_ users: [UserModel]) -> [MatchCardViewModel] {
        users.map { user in
            MatchCardViewModel(
                id: user.id,
                name: user.name,
                username: "@\(user.username)",
                email: user.email,
                phone: user.phone,
                city: user.address.city,
                companyName: user.company.name,
                profileImageURL: "https://i.pravatar.cc/300?u=\(user.id)",
                status: .pending
            )
        }
    }
}
