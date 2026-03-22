//
//  CreateBudgetScreen.swift
//  FirebaseDemoProject
//
//  Created by Mohammad Azam on 1/10/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct Budget: Codable, Identifiable {
    @DocumentID var id: String? 
    let name: String
    let limit: Double
}

struct CreateBudgetScreen: View {
    
    @State private var name: String = ""
    @State private var limit: Double?
    
    @Environment(BudgetStore.self) private var budgetStore
    @Environment(AuthenticationStore.self) private var authenticationStore
    @Environment(\.dismiss) private var dismiss
    
    private func saveBudget() {
        
        guard let limit = limit else { return }
        guard let uid = authenticationStore.user?.uid else { return }
        
        let budget = Budget(name: name, limit: limit)
        do {
            try budgetStore.createBudget(budget: budget, for: uid)
            dismiss() 
        } catch {
            print(error.localizedDescription)
        }
            
    }
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
            TextField("Limit", value: $limit, format: .currency(code: "USD"))
            Button("Create Budget") {
                saveBudget()
            }.buttonStyle(.borderedProminent)
        }
    }
}

