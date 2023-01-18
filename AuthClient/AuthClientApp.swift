import SwiftUI

@main
struct AuthClientApp: App {
    @StateObject private var tokenStore = TokenStore()

    var body: some Scene {
        WindowGroup {
          LaunchView().environmentObject(tokenStore)
        }
    }
}
