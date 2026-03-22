//
//  ContentView.swift
//  PerformanceAndDebugging
//
//  Created by Mohammad Azam on 10/28/25.
//

import SwiftUI

struct AddCustomerScreen: View {
    
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var phoneNumber: String = ""
    @State private var resetUUID: UUID = UUID()
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
            TextField("Address", text: $address)
            TextField("Phone", text: $phoneNumber)
            HStack {
                Button("Submit") {
                    // submit the form
                }
                Button("Reset") {
                    print("reset")
                    resetUUID = UUID()
                }
            }
        }.id(resetUUID)
    }
}

#Preview("AddCustomerScreen") {
    AddCustomerScreen()
}

/*
struct ProductListScreen: View {
    @State private var products: [Product] = []

    var body: some View {
        List(products) { product in
            Text(product.name)
        }
        .task {
            do {
                products = try await ProductService.shared.loadProducts()
            } catch {
                print("Failed to load products: \(error)")
            }
        }
    }
} */

struct Customer: Identifiable {
    let id = UUID()
    var name: String
    var address: String
    var phoneNumber: String
    var isPremium: Bool
}

struct CustomerListScreen: View {
    @State private var customers: [Customer] = [
        Customer(
            name: "Alice Johnson",
            address: "1200 Richmond Ave, Houston, TX 77042",
            phoneNumber: "713-555-1212",
            isPremium: true
        ),
        Customer(
            name: "Michael Green",
            address: "405 Sunset Blvd, Austin, TX 78704",
            phoneNumber: "512-555-3434",
            isPremium: false
        ),
        Customer(
            name: "Sophia Williams",
            address: "88 Main Street, Dallas, TX 75201",
            phoneNumber: "214-555-7788",
            isPremium: true
        ),
        Customer(
            name: "Daniel Thompson",
            address: "2305 Westheimer Rd, Houston, TX 77098",
            phoneNumber: "713-555-9090",
            isPremium: false
        ),
        Customer(
            name: "Emma Rodriguez",
            address: "900 Congress Ave, Austin, TX 78701",
            phoneNumber: "512-555-6543",
            isPremium: true
        ),
        Customer(
            name: "James Parker",
            address: "400 Travis St, Dallas, TX 75204",
            phoneNumber: "214-555-3322",
            isPremium: false
        ),
        Customer(
            name: "Olivia Martinez",
            address: "1101 Shepherd Dr, Houston, TX 77019",
            phoneNumber: "713-555-7878",
            isPremium: true
        ),
        Customer(
            name: "Ethan Davis",
            address: "77 Rainey St, Austin, TX 78701",
            phoneNumber: "512-555-1122",
            isPremium: false
        ),
        Customer(
            name: "Ava Wilson",
            address: "500 Elm St, Dallas, TX 75202",
            phoneNumber: "214-555-4555",
            isPremium: true
        ),
        Customer(
            name: "William Garcia",
            address: "2100 Memorial Dr, Houston, TX 77007",
            phoneNumber: "713-555-9999",
            isPremium: false
        )
    ]

    @State private var name: String = ""

    var body: some View {
        VStack {
            Text("Customers (\(customers.count))")
                .font(.title)
            TextField("Name", text: $name)
  
            List(customers) { customer in
                CustomerCellView(customer: customer)
                    .id(UUID())
            }
        }
    }
}

struct CustomerCellView: View {
    let customer: Customer
    @State private var isPremium: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(customer.name)
                .font(.headline)
            Text(customer.address)
            Text(customer.phoneNumber)
            Toggle(isOn: $isPremium) {
                Text("Is Premium")
            }
            if customer.isPremium {
                Text("Premium Member")
                    .foregroundStyle(.yellow)
            }
        }
        .padding()
    }
}

#Preview {
    CustomerListScreen()
}
