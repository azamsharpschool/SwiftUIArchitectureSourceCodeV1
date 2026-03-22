//
//  ContentView.swift
//  OuluBankR1
//
//  Created by Mohammad Azam on 2/13/25.
//

import SwiftUI

struct Product: Equatable {
    let price: Double
}

struct ProductFilterState {
    
    var min: Double?
    var max: Double?
    
    func filteredProducts(_ products: [Product]) -> [Product] {
            
        guard let min = min,
                  let max = max else { return [] }
            
            return products.filter {
                $0.price >= min && $0.price <= max
        }
    }
    
}

struct ContentView: View {
    
    @Environment(\.aprService) private var aprService
    
    @State private var ssn: String = ""
    @State private var apr: Double?
    @State private var message: String?
    
    @State private var min: Double? = 10
    @State private var max: Double? = 100
    
    @State private var products: [Product] = []
    
    @State private var productFilterState = ProductFilterState()
    
    private var isFormValid: Bool {
        ssn.isSSN && !ssn.isEmptyOrWhiteSpace
    }
    
    var body: some View {
        Form {
            TextField("Enter ssn", text: $ssn)
                .accessibilityIdentifier("ssnTextField")
            Button("Calculate APR") {
                Task {
                    do {
                        apr = try await aprService.getAPR(ssn: ssn)
                    } catch {
                        message = error.localizedDescription 
                    }
                }
            }
            .accessibilityIdentifier("calculateAPRButton")
            .disabled(!isFormValid)
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity, alignment: .center)
            
            if let apr {
                Text("\(apr)")
                    .accessibilityIdentifier("aprText")
            }
            
            if let message {
                Text("\(message)")
                    .accessibilityIdentifier("messageText")
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
