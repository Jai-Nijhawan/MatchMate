//
//  MatchCardView.swift
//  MatchMate
//
//  Created by Jai Nijhawan on 05/03/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct MatchCardView: View {
    let viewModel: MatchCardViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            WebImage(url: URL(string: viewModel.profileImageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 200, height: 200)
            .clipShape(Circle())
            
            Text(viewModel.name)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 6) {
                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(viewModel.city)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "building.2")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(viewModel.companyName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            if viewModel.isPending {
                HStack(spacing: 16) {
                    Button(action: viewModel.onDecline) {
                        HStack {
                            Image(systemName: "xmark")
                            Text("Decline")
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.red)
                        .cornerRadius(8)
                    }
                    
                    Button(action: viewModel.onAccept) {
                        HStack {
                            Image(systemName: "checkmark")
                            Text("Accept")
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.green)
                        .cornerRadius(8)
                    }
                }
            } else {
                statusBadge
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var statusBadge: some View {
        Text(viewModel.isAccepted ? "Member Accepted" : "Member Declined")
            .font(.subheadline.weight(.semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(viewModel.isAccepted ? Color.green : Color.red)
            .cornerRadius(8)
    }
}

#Preview("Pending") {
    MatchCardView(
        viewModel: MatchCardViewModel(
            id: 1,
            name: "Leanne Graham",
            username: "@Bret",
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
    .padding()
}

#Preview("Accepted") {
    MatchCardView(
        viewModel: MatchCardViewModel(
            id: 1,
            name: "Leanne Graham",
            username: "@Bret",
            email: "Sincere@april.biz",
            phone: "1-770-736-8031",
            city: "Gwenborough",
            companyName: "Romaguera-Crona",
            profileImageURL: "https://i.pravatar.cc/300?u=1",
            status: .accepted,
            onAccept: {},
            onDecline: {}
        )
    )
    .padding()
}

#Preview("Declined") {
    MatchCardView(
        viewModel: MatchCardViewModel(
            id: 1,
            name: "Leanne Graham",
            username: "@Bret",
            email: "Sincere@april.biz",
            phone: "1-770-736-8031",
            city: "Gwenborough",
            companyName: "Romaguera-Crona",
            profileImageURL: "https://i.pravatar.cc/300?u=1",
            status: .declined,
            onAccept: {},
            onDecline: {}
        )
    )
    .padding()
}
