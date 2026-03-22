//
//  ContentView.swift
//  HandlingStoreEventsInView
//
//  Created by Mohammad Azam on 9/19/25.
//

import SwiftUI
import Observation

struct Dependent {
    let id: UUID
    let name: String
    let dob: Date
}

struct User {
    let id: UUID
    let name: String
    var dependents: [Dependent] = []
}

@Observable
class UserStore {
    
    var users: [User] = [
        User(id: UUID(), name: "Alice"),
        User(id: UUID(), name: "Bob"),
        User(id: UUID(), name: "Charlie"),
        User(id: UUID(), name: "Daisy")
    ]
    
    func addDependent(_ dependent: Dependent, to userId: UUID) async throws {
        
        guard let index = users.firstIndex(where: { $0.id == userId }) else {
            return
        }
        
        users[index].dependents.append(dependent)
    }
    
}

struct InsuranceRate {
    let monthlyPremium: Decimal
    let deductible: Decimal
    let coverageAmount: Decimal
}

@Observable
class InsuranceStore {
    
    func calculateInsuranceRates(userId: UUID) async throws -> InsuranceRate? {
        InsuranceRate(
            monthlyPremium: Decimal(199.99),
            deductible: Decimal(1000),
            coverageAmount: Decimal(50000)
        )
    }
}

struct ContentView: View {
    
    @Environment(UserStore.self) private var userStore
    @Environment(InsuranceStore.self) private var insuranceStore
    @State private var insuranceRate: InsuranceRate?
    
    let userId = UUID()
    
    private func addDependent() async {
        let dependent = Dependent(id: UUID(), name: "Nancy", dob: Date())
        do {
            // add dependent to user management store
            try await userStore.addDependent(dependent, to: userId)
            insuranceRate = try await insuranceStore.calculateInsuranceRates(userId: userId)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        VStack {
            Button("Add Dependent") {
                Task { await addDependent() }
            }
            
            if let insuranceRate {
                Text("Monthly Premium: \(insuranceRate.monthlyPremium)")
                Text("Deductible: \(insuranceRate.deductible)")
                Text("Coverage Amount: \(insuranceRate.coverageAmount)")
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(UserStore())
        .environment(InsuranceStore())
}
