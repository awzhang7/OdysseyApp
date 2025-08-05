//
//  AuthManager.swift
//  Odyssey
//
//  Created by Andrew Zhang on 2/16/25.
//

import FirebaseAuth
import Firebase

import SwiftUI
import MapKit

class AuthManager: ObservableObject {
    @Published var user: User?

    init() {
        // Listen for authentication state changes
        Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
        }
    }

    // Sign Up with Email & Password
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                completion(.success(user))
            }
        }
    }

    // Log In with Email & Password
    func logIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                completion(.success(user))
            }
        }
    }

    // Log Out
    func logOut() {
        try? Auth.auth().signOut()
        self.user = nil
    }
}



