//
//  BudgetAppWorkshopTests.swift
//  BudgetAppWorkshopTests
//
//  Created by Mohammad Azam on 12/12/24.
//

import Testing
import SwiftData
import XCTest
@testable import BudgetAppWorkshop

struct BudgetAppWorkshopTests {
    
    private var context: ModelContext!
    
    @MainActor
    init() {
        context = mockContainer.mainContext
    }
    
    @Test func throwExceptionWhenDuplicateBudgetIsSaved() {
        
        // Create a budget instance
        let budget = Budget(name: "Vacation", limit: 100)
        try! budget.save(context: context)
        
        let anotherBudget = Budget(name: "Vacation", limit: 500)
        
        #expect(throws: BudgetError.duplicateName) {
            try anotherBudget.save(context: context)
          }
    }
    
    // What value does this test brings
    @Test func saveBudgetSuccessfully() throws {
        // Create a budget instance
        let budget = Budget(name: "Vacation", limit: 100)
        
        // Insert the budget into the context
        context.insert(budget)
        
        // Save the context
        try context.save()
        
        // Fetch the budget to confirm it was saved
        let predicate = #Predicate<Budget> { $0.name == "Vacation" }
        let fetchDescriptor = FetchDescriptor<Budget>(predicate: predicate)
        let results = try context.fetch(fetchDescriptor)
        
        #expect(results.count == 1)
        #expect(results.first?.name == "Vacation")
        #expect(results.first?.limit == 100)
    }
    
}
