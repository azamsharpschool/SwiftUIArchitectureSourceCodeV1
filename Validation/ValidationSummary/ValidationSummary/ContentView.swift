//
//  LoginScreen.swift
//  Learn
//
//  Created by Mohammad Azam on 12/7/24.
//

import SwiftUI

struct ValidationSummary: View {
    
    let validationErrors: [String]
      
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !validationErrors.isEmpty {
                Text("Validation Errors")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding(.bottom, 4)
                
                ForEach(validationErrors, id: \.self) { validationMessage in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text(validationMessage)
                            .foregroundColor(.primary)
                            .font(.body)
                    }
                }
                .padding(.leading, 4)
            }
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.red, lineWidth: 1)
        )
        .padding(.horizontal)
    }
}


struct LoginScreen: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var validationErrors: [String] = []

    private func validateForm() -> Bool {
        
        validationErrors = []
        
        if username.isEmpty {
            validationErrors.append("Username cannot be empty.")
        }
        
        if password.isEmpty {
            validationErrors.append("Password cannot be empty.")
        }
        
        return validationErrors.isEmpty
    }
    
    var body: some View {
        Form {
            TextField("Username", text: $username)
            SecureField("Password", text: $password)
            Button("Login") {
                if validateForm() {
                    // authenticate the user
                }
            }
            
            if !validationErrors.isEmpty {
                ValidationSummary(validationErrors: validationErrors)
            }
            
        }.navigationTitle("Login")
    }
}

#Preview {
    NavigationStack {
        LoginScreen()
    }
}
