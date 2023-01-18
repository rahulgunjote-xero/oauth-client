import SwiftUI

struct HomeView: View {
  @EnvironmentObject  var tokenStore: TokenStore

    var body: some View {
      ScrollView {
        Text("Header")
        Text(tokenStore.tokenResponse?.decodedHeader() ?? "Error decoding header from access token")
        Text("Payload")
        Text(tokenStore.tokenResponse?.decodedPayload() ?? "Error decoding payload from access token")
              
      }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
