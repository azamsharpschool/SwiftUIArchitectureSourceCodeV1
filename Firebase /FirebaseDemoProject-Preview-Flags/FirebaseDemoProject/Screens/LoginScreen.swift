//
//  LoginScreen.swift
//  FirebaseDemoProject
//
//  Created by Mohammad Azam on 10/26/25.
//

import SwiftUI
import FirebaseAuth

struct LoginScreen: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var message: String?
    
    @Environment(AuthenticationStore.self) private var authenticationStore
    
    private func login() async {
        do {
            try await authenticationStore.login(email: email, password: password)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        Form {
            TextField("Email", text: $email)
            SecureField("Password", text: $password)
            Button("Login") {
                Task { await login() }
            }
        }
    }
}

#Preview {
    LoginScreen()
        .environment(AuthenticationStore())
}
