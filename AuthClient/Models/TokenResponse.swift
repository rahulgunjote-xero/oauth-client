import Foundation

struct TokenResponse: Codable {
    let expiresIn: Int
    let accessToken, idToken, scope, tokenType: String
    let refreshToken: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case idToken = "id_token"
        case scope
        case tokenType = "token_type"
    }
}

