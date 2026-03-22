//
//  ContentView.swift
//  TestingPresentationLogic
//
//  Created by Mohammad Azam on 10/4/25.
//

import SwiftUI

extension String {
    
    var isEmptyOrWhitespace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isValidPassword: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).count >= 10
    }
    
    var isEmail: Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex)
            .evaluate(with: self)
    }
}

struct RegisterScreen: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    private var isFormValid: Bool {
        !email.isEmptyOrWhitespace &&
        !password.isEmptyOrWhitespace &&
        password.isValidPassword &&
        email.isEmail
    }
    
    var body: some View {
        Form {
            TextField("Email", text: $email)
            TextField("Password", text: $password)
            Button("Register") {
                
            }.disabled(!isFormValid)
        }
    }
}

#Preview {
    RegisterScreen()
}
