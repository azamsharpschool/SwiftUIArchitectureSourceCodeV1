//
//  AddBudgetScreen.swift
//  BudgetAppWorkshop
//
//  Created by Mohammad Azam on 3/26/24.
//

import SwiftUI

struct AddBudgetScreen: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var limit: Double?
    @State private var errorMessage: String = ""
    
    private var isFormValid: Bool {
        
        guard let limit = limit else {
            return false
        }
        
        return !name.isEmptyOrWhitespace && limit > 0 
    }
    
    private func saveBudget() {
        do {
            let budget = Budget(name: name, limit: limit!)
            try budget.save(context: context)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
                .accessibilityIdentifier("budgetNameTextField")
                .textInputAutocapitalization(.never)
            TextField("Limit", value: $limit, format: .number)
                .accessibilityIdentifier("budgetLimitTextField")
            Text(errorMessage)
        }
        .navigationTitle("Add Budget")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    saveBudget()
                }.disabled(!isFormValid)
                    .accessibilityIdentifier("saveBudgetButton")
            }
        }
    }
}

#Preview { @MainActor in
    NavigationStack {
        AddBudgetScreen()
    }.modelContainer(for: Budget.self, inMemory: true)
}
