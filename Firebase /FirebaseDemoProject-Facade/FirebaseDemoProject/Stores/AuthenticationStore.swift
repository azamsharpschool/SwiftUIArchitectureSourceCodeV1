//
//  AuthenticationStore.swift
//  FirebaseDemoProject
//
//  Created by Mohammad Azam on 1/11/26.
//

import Foundation
import Observation
import FirebaseAuth

struct AuthenticatedUser {
    let uid: String
    let email: String
}

@Observable
class AuthenticationStore {
    
    var user: AuthenticatedUser?
    private var handle: AuthStateDidChangeListenerHandle?
    private let auth: Auth
    
    let isPreview: Bool
    
    init(auth: Auth = .auth(), isPreview: Bool = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1") {
        self.auth = auth
        self.isPreview = true
        
        if isPreview {
            user = AuthenticatedUser(uid: "u123", email: "johndoe@gmail.com")
            return
        }
        
        if let current = auth.currentUser {
            self.user = AuthenticatedUser(uid: current.uid, email: current.email ?? "")
        } else {
            self.user = nil
        }
        
        handle = auth.addStateDidChangeListener { [weak self] _, firebaseUser in
            
            guard let self else { return }
            
            if let firebaseUser {
                self.user = AuthenticatedUser(
                    uid: firebaseUser.uid,
                    email: firebaseUser.email ?? ""
                )
            } else {
                self.user = nil
            }
        }
    }
    
    func login(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }
    
    func createUser(email: String, password: String) async throws {
        try await auth.createUser(withEmail: email, password: password)
    }
    
    deinit {
        if let handle {
            auth.removeStateDidChangeListener(handle)
        }
    }
}
