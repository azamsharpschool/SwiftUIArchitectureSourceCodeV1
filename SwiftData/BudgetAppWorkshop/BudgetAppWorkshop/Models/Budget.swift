//
//  Budget.swift
//  BudgetAppWorkshop
//
//  Created by Mohammad Azam on 12/11/24.
//

import Foundation
import SwiftData


@Model
class Budget {
    
    // CloudKit does not support unique constraints
    //#Unique<Budget>([\.name])
    
    var name: String = ""
    var limit: Double = 0.0
    @Relationship(deleteRule: .cascade)
    var expenses: [Expense]? = []
    
    var spent: Double {
        expenses?.reduce(0) { price, expense in
            price + (expense.price * Double(expense.quantity))
        } ?? 0.0 
    }
    
    var remaining: Double {
        limit - spent
    }
    
    
    init(name: String, limit: Double) {
        self.name = name
        self.limit = limit
    }
    
    private func isUniqueName(context: ModelContext, name: String) throws -> Bool {
       
        let predicate = #Predicate<Budget> { budget in
            budget.name.localizedStandardContains(name)
        }

        let fetchDescriptor = FetchDescriptor<Budget>(predicate: predicate)
        let results: [Budget] = try context.fetch(fetchDescriptor)
        return results.isEmpty
    }
    
    func save(context: ModelContext) throws {
        
        if try !isUniqueName(context: context, name: name) {
            throw BudgetError.duplicateName
        }
        
        context.insert(self)
        try context.save()
       
    }
}
