//
//  RegistrationScreen.swift
//  FirebaseDemoProject
//
//  Created by Mohammad Azam on 10/26/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct User: Codable {
    let uid: String
    let firstName: String
    let lastName: String
}

struct RegistrationScreen: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    
    @State private var message: String?
    
    @Environment(AuthenticationStore.self) private var authenticationStore
    @Environment(BudgetStore.self) private var budgetStore
    
    let firestore = FirebaseFirestore.Firestore.firestore()
    
    private func register() async {
        do {
            
            try await authenticationStore.createUser(email: email, password: password)
            
            guard let uid = authenticationStore.user?.uid else {
                return
            }
            
            // create user
            let user = User(uid: uid, firstName: firstName, lastName: lastName)
            
            try firestore.collection("users")
                .document(user.uid)
                .setData(from: user)
            
        } catch {
            message = "Registration failed: \(error.localizedDescription)"
        }
    }
    
    var body: some View {
        Form {
            TextField("Email", text: $email)
            SecureField("Password", text: $password)
            TextField("First name", text: $firstName)
            TextField("Last name", text: $lastName)
            
            Button("Register") {
                Task { await register() }
            }
            
            if let message {
                Text(message)
            }
            
        }
        .navigationTitle("Registration")
    }
}

#Preview {
    NavigationStack {
        RegistrationScreen()
    }.environment(AuthenticationStore())
}


