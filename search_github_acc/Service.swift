import Foundation
import UIKit

class Service {
    static let shared = Service()
    private init() {}
    
    private let baseURL = "https://api.github.com"
    
    func searchUsers(query: String, completion: @escaping (Result<UserSearchResponse, Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/search/users?q=\(encodedQuery)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        performRequest(url: url, responseType: UserSearchResponse.self, completion: completion)
    }
    
    func getUserDetail(username: String, completion: @escaping (Result<UserDetail, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/users/\(username)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        performRequest(url: url, responseType: UserDetail.self, completion: completion)
    }
    
    private func performRequest<T: Codable>(url: URL, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(responseType, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    
    var localizedDescription: String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .noData: return "No data received"
        }
    }
}

func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }
    
    DispatchQueue.global(qos: .background).async {
        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            DispatchQueue.main.async {
                completion(image)
            }
        } else {
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
}
