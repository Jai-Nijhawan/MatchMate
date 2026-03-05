import Foundation

struct MatchCardViewModel: Identifiable, Equatable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String
    let city: String
    let companyName: String
    let profileImageURL: String
    let status: MatchStatus
    
    var onAccept: () -> Void
    var onDecline: () -> Void
    
    var isPending: Bool { status == .pending }
    var isAccepted: Bool { status == .accepted }
    var isDeclined: Bool { status == .declined }
    
    static func == (lhs: MatchCardViewModel, rhs: MatchCardViewModel) -> Bool {
        lhs.id == rhs.id &&
        lhs.status == rhs.status
    }
}
