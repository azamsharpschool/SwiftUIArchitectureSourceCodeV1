//
//  MultipleSheetsView.swift
//  BasicSheets
//
//  Created by Mohammad Azam on 8/26/25.
//

import SwiftUI

struct MultipleSheetsView: View {
    
    let customers: [Customer] = [
        Customer(name: "Alice Johnson"),
        Customer(name: "Bob Smith"),
        Customer(name: "Charlie Davis"),
        Customer(name: "Diana Roberts"),
        Customer(name: "Ethan Brown")
    ]
    
    private enum Sheet: Identifiable {
        case addCustomer
        case customerDetails(Customer)
        
        var id: String {
            switch self {
            case .addCustomer:
                return "addCustomer"
            case .customerDetails(let customer):
                return customer.id.uuidString
            }
        }
    }
    
    @State private var activeSheet: Sheet?
    
    
    @State private var showAddCustomerSheet = false
    @State private var selectedCustomer: Customer?
    @State private var showLegalNoticeSheet = false
    @State private var showEditCustomerSheet = false
    @State private var showDeleteCustomerSheet = false
    
    
    var body: some View {
        List(customers) { customer in
            Text(customer.name)
                .onTapGesture {
                    activeSheet = .customerDetails(customer)
                //  selectedCustomer = customer
            }
        }.toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Customer") {
                    activeSheet = .addCustomer
                    //showAddCustomerSheet = true
                }
            }
        }
        .sheet(item: $activeSheet) { activeSheet in
            switch activeSheet {
                case .addCustomer:
                    Text("Add Customer")
                case .customerDetails(let customer):
                    Text("Customer Details \(customer.name)")
            }
        }
        
        .sheet(isPresented: $showAddCustomerSheet) {
            Text("ShowAddCustomerSheet")
        }
        .sheet(item: $selectedCustomer) { customer in
            Text(customer.name)
        }
        .sheet(isPresented: $showLegalNoticeSheet) {
            Text("Show Legal Notice")
        }
        .sheet(isPresented: $showEditCustomerSheet) {
            Text("Edit Customer Sheet")
        }
    }
}

#Preview {
    NavigationStack {
        MultipleSheetsView()
    }
}
