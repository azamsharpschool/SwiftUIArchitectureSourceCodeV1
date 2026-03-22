//
//  DecoupleViewsFromNavigation.swift
//  SwiftUIArchitectureBook
//
//  Created by Mohammad Azam on 8/22/25.
//

import SwiftUI

struct DecoupleViewsFromNavigation: View {
    
    let customers = [Customer(name: "John Doe"), Customer(name: "Mary Doe")]
    
    var body: some View {
        NavigationStack {
            CustomerListView(customers: customers)
                .navigationDestination(for: Customer.self) { customer in
                    CustomerDetailScreen(customer: customer)
                }
        }
    }
}

struct CustomerListView: View {
    
    let customers: [Customer]
    
    var body: some View {
        List(customers) { customer in
            NavigationLink(value: customer) {
                Text(customer.name)
            }
        }
    }
}

#Preview {
    DecoupleViewsFromNavigation()
}
