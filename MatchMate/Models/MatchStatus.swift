//
//  MatchStatus.swift
//  MatchMate
//
//  Created by Jai Nijhawan on 05/03/26.
//

import Foundation

enum MatchStatus: String, Codable, CaseIterable {
    case pending
    case accepted
    case declined
}
