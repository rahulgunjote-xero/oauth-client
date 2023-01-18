import Foundation

enum AuthError: LocalizedError {
    case resourceError(String)
    case unknown
    case failedToSetAuthURL
    case cancelled
    case callbackMissingCallbackURL
    case errorReturnedFromAuthorize(String)
    case callbackMissingCode
    case callbackMissingUserId
    case failedToGetTokenEndpoint
    case tokenRequestFailed(Error)
    case unableToParseTokenResponse

    var localizedDescription: String {
        switch self {
        case .resourceError(let status):
            return "Status code: \(status)"
        case .unknown:
            return "error unknown"
        case .failedToSetAuthURL:
            return "failed to set authorisation URL"
        case .cancelled:
            return "cancelled login"
        case .callbackMissingCallbackURL:
            return "authorisation response does not include the callback URL"
        case .errorReturnedFromAuthorize(let message):
            return "error returned from authorisation request \(message)"
        case .callbackMissingCode:
            return "authorisation response does not include the code"
        case .callbackMissingUserId:
          return "authorisation response does not include the user id"
        case .tokenRequestFailed(let error):
            return "unable to get token: \(error.localizedDescription)"
        case .unableToParseTokenResponse:
            return "unable to parse token response"
        case .failedToGetTokenEndpoint:
            return "unable to get token endpoint - check the URL is correct and set in OAuthConfig"
        }
    }
}
