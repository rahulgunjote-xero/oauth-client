import Foundation

final class TokenStore: ObservableObject {
  @Published var tokenResponse: TokenResponse?
  
  init() {
    self.tokenResponse = fetchStoredToken()
  }
  
  func setToken(token: TokenResponse?) {
    guard let token = token else {
      self.tokenResponse = nil
      UserDefaults.resetStandardUserDefaults()
      return
    }
    
    var encodedData: Data?
    do {
      encodedData = try JSONEncoder().encode(token)
    } catch {
      UserDefaults.resetStandardUserDefaults()
      return
    }
    
    guard let data = encodedData else {
      UserDefaults.resetStandardUserDefaults()
      return
    }
    UserDefaults.standard.set(data, forKey: "token_response")
    self.tokenResponse = token
  }
  
  func checkStored() -> Bool {
    guard let tokenResp = fetchStoredToken() else {
      return false
    }
    self.tokenResponse = tokenResp
    return true
  }
  
  private func fetchStoredToken() -> TokenResponse? {
    var tokenResponse: TokenResponse?
    if let encodedResponse = UserDefaults.standard.value(forKey: "token_response") as? Data {
      do {
        tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: encodedResponse)
      } catch {
        tokenResponse = nil
      }
    }
    return tokenResponse
  }
}


