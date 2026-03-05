import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    case serverError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .networkError(let error):
            return error.localizedDescription
        case .serverError(let code):
            return "Server error: \(code)"
        }
    }
}

protocol NetworkServiceProtocol {
    func fetchUsers() async throws -> [UserModel]
}

final class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    
    private let baseURL = "https://jsonplaceholder.typicode.com/users"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchUsers() async throws -> [UserModel] {
        guard let url = URL(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.noData
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            let users = try JSONDecoder().decode([UserModel].self, from: data)
            return users
        } catch let error as NetworkError {
            throw error
        } catch let error as DecodingError {
            print("Decoding error: \(error)")
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.networkError(error)
        }
    }
}
