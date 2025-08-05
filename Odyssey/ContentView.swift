import SwiftUI
import MapKit
import FirebaseAuth

struct ContentView: View {
    @StateObject var authManager = AuthManager()

    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var errorMessage: String?

    @State private var showLoginScreen = false

    var body: some View {
        if showLoginScreen {
            loginView
        } else {
            landingView
        }
    }

    var landingView: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 30) {
                Image("earth")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .clipShape(Circle())  // Optional for a round planet look
                    .background(Color.black)

                VStack(spacing: 10) {
                    Text("The world is your")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("oyster")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Welcome to Odyssey, your new AI travel assistant.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }

                Button(action: {
                    withAnimation {
                        showLoginScreen = true
                    }
                }) {
                    Text("Get Started")
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemMint))
                        .cornerRadius(15)
                        .padding(.horizontal, 40)
                }
            }
            .padding(.top, 60)
        }
    }

    var loginView: some View {
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
                        handleAuthResult(result)
                    }
                } else {
                    authManager.logIn(email: email, password: password) { result in
                        handleAuthResult(result)
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

    func handleAuthResult(_ result: Result<FirebaseAuth.User, Error>) {

        switch result {
        case .success(let user):
            errorMessage = nil
            print("User: \(user)") // or use user info
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }

}

#Preview {
    ContentView()
}
