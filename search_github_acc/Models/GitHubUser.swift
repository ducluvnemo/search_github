import Foundation

struct GitHubUser: Codable {
    let id: Int
    let login: String
    let avatarUrl: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case id, login, type
        case avatarUrl = "avatar_url"
    }
}

struct UserSearchResponse: Codable {
    let items: [GitHubUser]
}

struct UserDetail: Codable {
    let id: Int
    let login: String
    let avatarUrl: String
    let name: String?
    let bio: String?
    let followers: Int
    let following: Int
    let publicRepos: Int
    
    enum CodingKeys: String, CodingKey {
        case id, login, name, bio, followers, following
        case avatarUrl = "avatar_url"
        case publicRepos = "public_repos"
    }
}
