import SwiftUI

struct LaunchView: View {
  @EnvironmentObject  var tokenStore: TokenStore

    var body: some View {
      ZStack {
          if tokenStore.tokenResponse != nil {
              NavigationView {
                  HomeView()
                  .toolbar {
                      Button(action: {
                          tokenStore.setToken(token: nil)
                      }) {
                         Text("Logout")
                      }
                  }
              }
          } else {
              LoginView()
          }
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
