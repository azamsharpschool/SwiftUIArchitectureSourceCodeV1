//
//  TestingSwiftDataModelsTests.swift
//  TestingSwiftDataModelsTests
//
//  Created by Mohammad Azam on 10/4/25.
//

import Testing
import SwiftData
@testable import TestingSwiftDataModels

struct TestingSwiftDataModelsTests {
    
    private let context: ModelContext!
    
    @MainActor
    init() {
        let container = try! ModelContainer(for: Budget.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        context = container.mainContext
    }
    
    @Test func user_save_budget_successfully() throws {
        // your test here!
    }
}

