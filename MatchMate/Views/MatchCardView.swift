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
    var onAccept: () -> Void = {}
    var onDecline: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .bottom) {
                WebImage(url: URL(string: viewModel.profileImageURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 200, height: 200)
                .clipShape(Circle())
            }
            
            VStack(spacing: 8) {
                Text(viewModel.name)
                    .font(.title3.weight(.bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text("@\(viewModel.username)")
                    .font(.subheadline)
                    .foregroundColor(.pink)
                
                HStack(spacing: 8) {
                    pillBadge(icon: "mappin.and.ellipse", text: viewModel.city, color: .blue)
                    
                    pillBadge(icon: "building.2", text: viewModel.companyName, color: .purple)
                }
                .padding(.horizontal, 8)
            }
            
            if viewModel.isPending {
                HStack(spacing: 16) {
                    Button(action: onDecline) {
                        HStack {
                            Image(systemName: "xmark")
                            Text("Decline")
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.red)
                        .cornerRadius(25)
                    }
                    
                    Button(action: onAccept) {
                        HStack {
                            Image(systemName: "checkmark")
                            Text("Accept")
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.green)
                        .cornerRadius(25)
                    }
                }
                .padding(.horizontal, 8)
            } else {
                statusBadge
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 5)
    }
    
    private func pillBadge(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
            Text(text)
                .font(.caption)
                .lineLimit(1)
        }
        .foregroundColor(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(color.opacity(0.1))
        .cornerRadius(20)
    }
    
    private var statusBadge: some View {
        Text(viewModel.isAccepted ? "Member Accepted" : "Member Declined")
            .font(.subheadline.weight(.semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(viewModel.isAccepted ? Color.green : Color.red)
            .cornerRadius(25)
            .padding(.horizontal, 8)
    }
}

#Preview("Pending") {
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
            status: .pending
        )
    )
    .padding()
}

#Preview("Accepted") {
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
            status: .accepted
        )
    )
    .padding()
}

#Preview("Declined") {
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
            status: .declined
        )
    )
    .padding()
}
