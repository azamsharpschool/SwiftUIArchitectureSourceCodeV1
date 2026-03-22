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
    
    @Environment(BudgetStoreFacade.self) private var budgetFacadeStore
    @Environment(AuthenticationStore.self) private var authenticationStore
    @State private var presentAddBudget: Bool = false
    
    var body: some View {
        List(budgetFacadeStore.budgets) { budget in
            Text(budget.name)
        }.task(id: authenticationStore.user?.uid) {
            
            if let uid = authenticationStore.user?.uid {
                budgetFacadeStore.startListening(uid: uid)
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
            budgetFacadeStore.stopListening()
        }
    }
}

#Preview {
    NavigationStack {
        BudgetListScreen()
    }
    .environment(AuthenticationStore())
    .environment(BudgetStoreFacade(PreviewBudgetStore()))
}
