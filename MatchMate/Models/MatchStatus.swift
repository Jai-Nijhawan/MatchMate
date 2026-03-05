import Foundation

enum MatchStatus: String, Codable, CaseIterable {
    case pending
    case accepted
    case declined
}
