//
//  MatchProfile.swift
//  MatchMate
//
//  Created by Jai Nijhawan on 05/03/26.
//

import Foundation
import SwiftData

@Model
final class MatchProfile {
    @Attribute(.unique) var id: Int
    var name: String
    var username: String
    var email: String
    var phone: String
    var city: String
    var companyName: String
    var profileImageURL: String
    var status: MatchStatus
    
    init(id: Int, name: String, username: String, email: String, 
         phone: String, city: String, companyName: String,
         profileImageURL: String, status: MatchStatus = .pending) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.phone = phone
        self.city = city
        self.companyName = companyName
        self.profileImageURL = profileImageURL
        self.status = status
    }
    
    static func from(userModel: UserModel) -> MatchProfile {
        MatchProfile(
            id: userModel.id,
            name: userModel.name,
            username: userModel.username,
            email: userModel.email,
            phone: userModel.phone,
            city: userModel.address.city,
            companyName: userModel.company.name,
            profileImageURL: "https://i.pravatar.cc/300?u=\(userModel.id)"
        )
    }
}
