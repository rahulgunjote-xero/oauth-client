import SwiftUI

struct LoginView: View {
  @State private var isLoading = false
  @State private var error: AuthError?
  
  var body: some View {
    ZStack {
      VStack {
        if isLoading {
          ProgressView()
        } else {
          HStack {
            Image(systemName: "person.circle")
            Button("Sign In") {
              isLoading.toggle()
              AuthService(completion: { res, err in
                DispatchQueue.main.async {
                  isLoading.toggle()
                 // modelData.setToken(token: res)
                  error = err
                }
              }).authenticate()
            }
          }
          .frame(width: 160, height: 20, alignment: .center)
          .padding()
          .foregroundColor(.white)
          .background(.blue)
          .cornerRadius(8)
          .disabled(isLoading)
        }
        
        if error != nil {
          Text(error?.localizedDescription ?? "error signing in")
            .foregroundColor(.red)
        }
      }
      .padding()
    }
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
  }
}
