//
//  APRServiceCreditScoreServiceTests.swift
//  OuluBankR1Tests
//
//  Created by Mohammad Azam on 2/15/25.
//

import Testing
@testable import OuluBankR1

struct APRServiceCreditScoreServiceTests {
    
    @Test
    func apr_service_calls_get_credit_score_on_credit_score_service() async throws {
        
        let validSSN = "123-45-6789"
        let expectedAPR = 3.2
        
        var mockCreditScoreService = MockCreditScoreService()
        
        try await confirmation("APRService did not call GetCreditScore on CreditScoreService", expectedCount: 1) { confirmation in
            // you need to make sure that mockCreditScoreService.getCreditScore is fired
            
            mockCreditScoreService.onGetCreditScore = { ssn in
                confirmation()
                return CreditScore(score: 500, lastUpdated: "02/02/2025", reportedBy: "Experian")
            }
            
            let aprService = APRService(creditScoreService: mockCreditScoreService)
            let actualAPR = try await aprService.getAPR(ssn: validSSN)
            #expect(actualAPR == expectedAPR)
        }
    }
    
    @Test
    func apr_service_does_not_call_get_credit_score_with_invalid_ssn() async throws {
        
        var mockCreditScoreService = MockCreditScoreService()
        
        await confirmation("APRService called CreditScoreService even with invalid SSN.", expectedCount: 0) { confirmation in
            
            mockCreditScoreService.onGetCreditScore = { ssn in
                confirmation()
                return CreditScore(score: 500, lastUpdated: "02/02/2025", reportedBy: "Experian")
            }
            
            let aprService = APRService(creditScoreService: mockCreditScoreService)
            let _ = try? await aprService.getAPR(ssn: "abc-de-frtg")
            
        }
        
    }
    
    
}
