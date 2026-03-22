//
//  BudgetListScreen.swift
//  FirebaseDemoProject
//
//  Created by Mohammad Azam on 1/10/26.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore

struct BudgetListScreen: View {
    
    @Environment(BudgetStore.self) private var budgetStore
    @Environment(AuthenticationStore.self) private var authenticationStore
    @State private var presentAddBudget: Bool = false
    
    var body: some View {
        List(budgetStore.budgets) { budget in
            Text(budget.name)
        }.task(id: authenticationStore.user?.uid) {
            
            if let uid = authenticationStore.user?.uid {
                budgetStore.startListening(uid: uid)
            }
        }.toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Budget") {
                    presentAddBudget = true
                }
            }
        }.sheet(isPresented: $presentAddBudget) {
            NavigationStack {
                CreateBudgetScreen()
            }
        }
        .onDisappear {
            budgetStore.stopListening()
        }
    }
}

#Preview {
    NavigationStack {
        BudgetListScreen()
    }
    .environment(AuthenticationStore())
    .environment(BudgetStore())
}
