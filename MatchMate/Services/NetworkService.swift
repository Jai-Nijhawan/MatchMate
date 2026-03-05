//
//  NetworkService.swift
//  MatchMate
//
//  Created by Jai Nijhawan on 05/03/26.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: String) async throws -> T
}

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

final class NetworkService: NetworkServiceProtocol {
    
    func request<T: Decodable>(_ endpoint: String) async throws -> T {
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.noData
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch let error as NetworkError {
            throw error
        } catch is DecodingError {
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.networkError(error)
        }
    }
}
