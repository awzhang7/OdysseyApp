import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var authManager = AuthManager()
    
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false // Toggle between login/signup
    @State private var errorMessage: String?

    var body: some View {
        
        Map()
        
        
        VStack {
            Text(isSignUp ? "Sign Up" : "Login")
                .font(.largeTitle)
                .bold()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: {
                if isSignUp {
                    authManager.signUp(email: email, password: password) { result in
                        switch result {
                        case .success(_):
                            errorMessage = nil
                        case .failure(let error):
                            errorMessage = error.localizedDescription
                        }
                    }
                } else {
                    authManager.logIn(email: email, password: password) { result in
                        switch result {
                        case .success(_):
                            errorMessage = nil
                        case .failure(let error):
                            errorMessage = error.localizedDescription
                        }
                    }
                }
            }) {
                Text(isSignUp ? "Sign Up" : "Log In")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Button(action: {
                isSignUp.toggle()
            }) {
                Text(isSignUp ? "Already have an account? Log in" : "Don't have an account? Sign up")
                    .foregroundColor(.blue)
            }
            .padding()

            if authManager.user != nil {
                Button(action: authManager.logOut) {
                    Text("Log Out")
                        .foregroundColor(.red)
                }
                .padding()
            }
        }
        .padding()
    }
}



#Preview{
    ContentView()
}
