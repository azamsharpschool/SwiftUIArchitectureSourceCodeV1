//
//  TestBehaviorNotImplementationDetailsTests.swift
//  TestBehaviorNotImplementationDetailsTests
//
//  Created by Mohammad Azam on 10/2/25.
//

import Foundation
import Testing
@testable import TestBehaviorNotImplementationDetails

class PaymentGatewayMock: PaymentGatewayProtocol {
    
    var isPerformPaymentCalled: Bool = false
    
    func performPayment(amount: Double) async throws -> PaymentReceipt {
        
        isPerformPaymentCalled = true
        
        // Simulate successful payment
        return PaymentReceipt(
            id: UUID(),
            amount: amount,
            date: Date(),
            status: "Success"
        )
    }
}

@MainActor
struct TestBehaviorNotImplementationDetailsTests {

    @Test func test_performPayment_is_called_on_gateway() async throws {
        
        let mockGateway = PaymentGatewayMock()
        let cartStore = CartStore(paymentGateway: mockGateway)
        _ = try await cartStore.processPayment(amount: 100.0)
        
        #expect(mockGateway.isPerformPaymentCalled == true)
    }
    
    @Test func test_performPayment_returns_receipt() async throws {
        let mockGateway = PaymentGatewayMock()
        let cartStore = CartStore(paymentGateway: mockGateway)
        try await cartStore.processPayment(amount: 100.0)
        
        #expect(cartStore.receipt?.amount == 100.0)
        #expect(cartStore.receipt?.status == "Success")
    }
}

