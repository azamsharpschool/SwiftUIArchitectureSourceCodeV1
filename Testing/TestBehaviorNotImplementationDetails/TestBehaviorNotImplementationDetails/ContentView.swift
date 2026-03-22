//
//  ContentView.swift
//  TestBehaviorNotImplementationDetails
//
//  Created by Mohammad Azam on 10/2/25.
//

import SwiftUI
import Observation
import Playgrounds
import FoundationModels

#Playground {
    URLSession
    let session = LanguageModelSession()
    let response = try await session.respond(to: "Hello")
    print(response.content)
}

struct PaymentReceipt: Codable, Equatable {
    let id: UUID
    let amount: Double
    let date: Date
    let status: String
}

protocol PaymentGatewayProtocol {
    func performPayment(amount: Double) async throws -> PaymentReceipt
}

class PaymentGateWay: PaymentGatewayProtocol {
    
    // add your published properties here.
    
    func performPayment(amount: Double) async throws -> PaymentReceipt {
        
        // add a delay
        try! await Task.sleep(for: .seconds(2.0))
        
        // Simulate successful payment
        return PaymentReceipt(
            id: UUID(),
            amount: amount,
            date: Date(),
            status: "Success"
        )
    }
}

@Observable
class CartStore {
    
    var receipt: PaymentReceipt?
    let paymentGateway: PaymentGatewayProtocol
    
    init(paymentGateway: PaymentGatewayProtocol = PaymentGateWay()) {
        self.paymentGateway = paymentGateway
    }
    
    func processPayment(amount: Double) async throws {
        receipt = try await paymentGateway.performPayment(amount: amount)
    }
    
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Foo") {
                Task {
                    let session = LanguageModelSession()
                    let response = try await session.respond(to: "List all states in USA.")
                    print(response.content)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
