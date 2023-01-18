import Foundation

struct OAuthConfig {
    static let clientID = "xero_go"
    static let authority: URL = URL(string: "https://localhost:5001")!
    static let authorizationURI = authority.appending(components: "connect", "authorize")//URL(string: "\(authority.string!)/connect/authorize")!
    static let tokenURI: URL = authority.appending(components: "connect", "token")//URL(string: "\(authority.string!)/connect/token")!
    static let redirectURI: URL = URL(string: "auth://com.xero.exampleapp")!
    static let scope = "openid profile bff_api mfa_setup offline_access"
}
