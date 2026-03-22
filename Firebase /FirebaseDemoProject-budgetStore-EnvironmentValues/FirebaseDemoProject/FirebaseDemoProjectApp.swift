//
//  FirebaseDemoProjectApp.swift
//  FirebaseDemoProject
//
//  Created by Mohammad Azam on 10/26/25.
//

import SwiftUI
import SwiftUI
import FirebaseCore
import FirebaseAuth
import Observation
import FirebaseFirestore



@main
struct FirebaseDemoProjectApp: App {
    
    @State private var authenticationStore: AuthenticationStore?
    @State private var budgetStore: BudgetStore?
    
    init() {
        FirebaseApp.configure()
        _authenticationStore = State(initialValue: AuthenticationStore())
        _budgetStore = State(initialValue: BudgetStore(firestore: Firestore.firestore()))
    }
    
    var body: some Scene {
        WindowGroup {
            
            if let budgetStore {
                NavigationStack {
                    RootView()
                }
                .environment(authenticationStore)
                .environment(budgetStore)
            } else {
                ProgressView("Loading...")
            }
            
        }
    }
}

struct RootView: View {
    
    @Environment(AuthenticationStore.self) private var authenticationStore
    
    var body: some View {
        if authenticationStore.user == nil {
            LoginScreen()
        } else {
            BudgetListScreen()
        }
    }
}

