//
//  ContentView.swift
//  BasicSheets
//
//  Created by Mohammad Azam on 8/26/25.
//

import SwiftUI

struct Customer: Identifiable {
    let id = UUID()
    let name: String
}

struct CustomerDetailScreen: View {
    
    let customer: Customer
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack {
            Text(customer.name)
            Button("Show Address") {
                isPresented = true
            }
        }.sheet(isPresented: $isPresented) {
            Text("1200 Richmond Ave, Houston, TX")
        }
    }
}

struct ContentView: View {
    
    @State private var isPresented: Bool = false
    @State private var customer: Customer?
    @State private var showSheet: Bool = false
    
    var body: some View {
        VStack {
            Button("IsPresented") {
                isPresented = true
            }
            
            Button("ShowSheet") {
                showSheet = true
            }
            
            Button("Show Sheet for Customer") {
                customer = Customer(name: "John Doe")
            }
        }
        .sheet(isPresented: $showSheet, content: {
            Text("Sheet")

                .presentationDetents([.fraction(0.25), .medium, .large])
        })
        
        .sheet(item: $customer, content: { customer in
            CustomerDetailScreen(customer: customer)
        })
        
        .sheet(isPresented: $isPresented, onDismiss: {
            // fires when the sheet is dismissed
        }, content: {
            Text("Sheet Content")
        })
        .padding()
    }
}

#Preview {
    ContentView()
}
