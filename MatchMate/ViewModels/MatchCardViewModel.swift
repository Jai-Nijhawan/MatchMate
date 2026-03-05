//
//  MatchCardViewModel.swift
//  MatchMate
//
//  Created by Jai Nijhawan on 05/03/26.
//

import Foundation

struct MatchCardViewModel: Identifiable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String
    let city: String
    let companyName: String
    let profileImageURL: String
    var status: MatchStatus
    
    var isPending: Bool { status == .pending }
    var isAccepted: Bool { status == .accepted }
    var isDeclined: Bool { status == .declined }
}
