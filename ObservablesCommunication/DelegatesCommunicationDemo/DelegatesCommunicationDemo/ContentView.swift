//
//  ContentView.swift
//  DelegatesCommunicationDemo
//
//  Created by Mohammad Azam on 1/21/26.
//

import SwiftUI
import Observation

struct Dependent: Identifiable, Equatable {
    let id: Int
    let name: String
}

struct User: Identifiable, Equatable {
    let id: Int
    let name: String
    var dependents: [Dependent] = []
}

struct InsuranceRate: Equatable {
    let monthlyPremium: Decimal
    let deductible: Decimal
    let coverageAmount: Decimal
}

protocol UserStoreDelegate: AnyObject {
    func dependentAdded(dependent: Dependent, userId: Int) async
}

struct HTTPClient {
    
}

enum UserError: Error {
    case userNotFound
}

@Observable
class UserStore {
    
    let httpClient: HTTPClient
    weak var delegate: (any UserStoreDelegate)?
    
    var users: [User] = [
        User(id: 1, name: "Alice", dependents: [
            Dependent(id: 101, name: "Bob"),
            Dependent(id: 102, name: "Charlie")
        ]),
        User(id: 2, name: "David"),
        User(id: 3, name: "Emma", dependents: [
            Dependent(id: 103, name: "Sophia")
        ])
    ]
    
   
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    // add a dependent to the user
    func addDependent(_ dependent: Dependent, to userId: Int) async throws {
        
        // get the user
        guard let index = users.firstIndex(where: { $0.id == userId }) else { throw UserError.userNotFound }
        
        users[index].dependents.append(dependent)
        await delegate?.dependentAdded(dependent: dependent, userId: userId)
    }
    
}

@Observable
class InsuranceStore: UserStoreDelegate {
    
    let httpClient: HTTPClient
    var insuranceRate: InsuranceRate?
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func dependentAdded(dependent: Dependent, userId: Int) async {
        // calculate rates
        calculateInsuranceRates(dependent: dependent, userId: userId)
        print("dependentAdded InsuranceStore")
    }
    
    func loadCurrentInsuranceRates(userId: Int) {
        insuranceRate = InsuranceRate(
                   monthlyPremium: Decimal(Double.random(in: 300...600)),
                   deductible: Decimal(Double.random(in: 500...2000)),
                   coverageAmount: Decimal(Double.random(in: 10_000...50_000))
        )
    }
    
    private func calculateInsuranceRates(dependent: Dependent, userId: Int) {
        insuranceRate = InsuranceRate(
                   monthlyPremium: Decimal(Double.random(in: 300...600)),
                   deductible: Decimal(Double.random(in: 500...2000)),
                   coverageAmount: Decimal(Double.random(in: 10_000...50_000))
        )
    }
}

struct UserDetailScreen: View {
    
    let user: User
    @Environment(InsuranceStore.self) private var insuranceStore
    @Environment(UserStore.self) private var userStore
    @State private var dependentName: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(user.name)
                .font(.largeTitle)
            
            if let insuranceRate = insuranceStore.insuranceRate {
                Text(insuranceRate.coverageAmount, format: .currency(code: "USD"))
                Text(insuranceRate.deductible, format: .currency(code: "USD"))
                Text(insuranceRate.monthlyPremium, format: .currency(code: "USD"))
            }
            
            HStack {
                TextField("Dependent name", text: $dependentName)
                    .textFieldStyle(.roundedBorder)
                Button("Add Dependent") {
                    let dependent = Dependent(id: Int.random(in: 100...1000), name: dependentName)
                    Task {
                        try await userStore.addDependent(dependent, to: user.id)
                    }
                }
            }
            
            List(user.dependents) { dependent in
                Text(dependent.name)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .task {
            insuranceStore.loadCurrentInsuranceRates(userId: user.id)
        }
            
    }
}

#Preview("UserDetailScreen") {
    UserDetailScreen(user: User(id: 1, name: "Alice", dependents: [Dependent(id: 101, name: "Bob"),
                                                                    Dependent(id: 102, name: "Charlie")]))
        .environment(InsuranceStore(httpClient: HTTPClient()))
        .environment(UserStore(httpClient: HTTPClient()))
}

struct ContentView: View {
    
    @Environment(UserStore.self) private var userStore
    
    var body: some View {
        List(userStore.users) { user in
            NavigationLink {
                UserDetailScreen(user: user)
            } label: {
                VStack(alignment: .leading, spacing: 10) {
                    Text(user.name)
                    Text("Dependents: \(user.dependents.map { $0.name }.joined(separator: ", "))", )
                        .font(.caption)
                }
            }
        }.navigationTitle("Users")
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
    .environment(UserStore(httpClient: HTTPClient()))
    .environment(InsuranceStore(httpClient: HTTPClient()))
}
