import AuthenticationServices

final class AuthService: NSObject {
  
  
  let completion: (TokenResponse?, AuthError?) -> Void
  
  init(completion: @escaping (TokenResponse?, AuthError?) -> Void) {
    self.completion = completion
  }
  
  func authenticate() {
    let challenge = self.generateCodeChallenge()
    var components = URLComponents(url: OAuthConfig.authorizationURI, resolvingAgainstBaseURL: true)
    components?.queryItems = [
      URLQueryItem(name:"client_id", value: OAuthConfig.clientID),
      URLQueryItem(name:"redirect_uri", value: OAuthConfig.redirectURI.absoluteString),
      URLQueryItem(name:"response_type", value: "code"),
      URLQueryItem(name:"scope", value: OAuthConfig.scope),
      URLQueryItem(name:"code_challenge", value: Data(challenge.utf8).sha256.base64urlEncodedString()),
      URLQueryItem(name:"code_challenge_method", value: "S256"),
    ]
    guard let authorizationURL = components?.url else {
      self.completion(nil, .failedToSetAuthURL)
      return
    }
    print("Authorization request url: \(authorizationURL.absoluteString)")
    let session = ASWebAuthenticationSession(url: authorizationURL, callbackURLScheme: OAuthConfig.redirectURI.scheme)
    { [self] callbackURL, error in
      
      guard error == nil else {
        self.completion(nil, .cancelled)
        return
      }
      
      guard let callbackURL = callbackURL else {
        self.completion(nil, .callbackMissingCallbackURL)
        return
      }
      
      guard callbackURL.getQueryParam(value: "error") == nil else {
        self.completion(nil, .errorReturnedFromAuthorize(callbackURL.getQueryParam(value: "error")!))
        return
      }
      
      guard let code = callbackURL.getQueryParam(value: "code") else {
        self.completion(nil, .callbackMissingCode)
        return
      }
      
      self.exchangeCodeForToken(code: code, challenge: challenge)
    }
    session.presentationContextProvider = self
    session.prefersEphemeralWebBrowserSession = true
    session.start()
    
  }
  
  private func exchangeCodeForToken(code: String, challenge: String) {
    
    var components = URLComponents()
    components.queryItems = [
      URLQueryItem(name:"client_id", value: OAuthConfig.clientID),
//      URLQueryItem(name:"client_secret", value: "secret"),
      URLQueryItem(name:"redirect_uri", value: OAuthConfig.redirectURI.absoluteString),
      URLQueryItem(name:"grant_type", value: "authorization_code"),
      URLQueryItem(name:"code_verifier", value: challenge),
      URLQueryItem(name:"code", value: code)
    ]
    
    let headers: [String:String] = ["Content-Type": "application/x-www-form-urlencoded"]
    var request = URLRequest(url: OAuthConfig.tokenURI)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = components.query?.data(using: .utf8)
    print("Token request: \(request.debugDescription)")

    URLSession.shared.dataTask(with: request) {
      data,_,err in
      if err != nil {
        self.completion(nil, .tokenRequestFailed(err!))
        return
      }
      
      DispatchQueue.main.async {
        guard let data = data else {
          self.completion(nil, .unableToParseTokenResponse)
          return
        }
        do {
          print("Token reponse: \(String.init(data: data, encoding: .utf8) ?? "Nil optional")")
          let v = try JSONDecoder().decode(TokenResponse.self, from: data)
          self.completion(v, nil)
        } catch {
          self.completion(nil, .unableToParseTokenResponse)
        }
      }
    }.resume()
    
  }
  
  private func generateCodeChallenge() -> String {
    let challengeChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
    let challenge = (0..<128)
      .map { _ in challengeChars.randomElement()! }
      .reduce(into: "") { $0.append($1) }
    return challenge
    //return Data(challenge.utf8).sha256.base64urlEncodedString()
  }
}


extension AuthService: ASWebAuthenticationPresentationContextProviding {
  func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
    ASPresentationAnchor()
  }
}


