import SwiftUI
import SDWebImageSwiftUI

struct MatchCardView: View {
    let viewModel: MatchCardViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            if !viewModel.isPending {
                statusBadge
            }
            
            WebImage(url: URL(string: viewModel.profileImageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            
            VStack(spacing: 8) {
                Text(viewModel.name)
                    .font(.title3.weight(.bold))
                    .foregroundColor(.primary)
                
                Text(viewModel.username)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
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
                HStack(spacing: 32) {
                    Button(action: viewModel.onDecline) {
                        Image(systemName: "xmark")
                            .font(.title2.weight(.bold))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.red)
                            .clipShape(Circle())
                    }
                    
                    Button(action: viewModel.onAccept) {
                        Image(systemName: "checkmark")
                            .font(.title2.weight(.bold))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.green)
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    @ViewBuilder
    private var statusBadge: some View {
        if viewModel.isAccepted {
            Text("Member Accepted")
                .font(.caption.weight(.semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.green)
                .cornerRadius(12)
        } else if viewModel.isDeclined {
            Text("Member Declined")
                .font(.caption.weight(.semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.red)
                .cornerRadius(12)
        }
    }
}
