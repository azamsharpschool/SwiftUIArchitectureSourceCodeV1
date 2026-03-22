//
//  ListToDetailScreen.swift
//  SwiftUIArchitectureBook
//
//  Created by Mohammad Azam on 8/22/25.
//

import SwiftUI

struct Customer: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

struct CustomerListScreen: View {
    
    let customers = [Customer(name: "John Doe"), Customer(name: "Mary Doe")]
    
    var body: some View {
        NavigationStack {
            List(customers) { customer in
                NavigationLink(value: customer) {
                    Text(customer.name)
                }
            }.navigationDestination(for: Customer.self) { customer in
                CustomerDetailScreen(customer: customer)
            }
        }
    }
}

struct CustomerDetailScreen: View {
    var customer: Customer
    var body: some View {
        Text("Detail of \(customer.name)")
    }
}

#Preview {
    CustomerListScreen()
}
