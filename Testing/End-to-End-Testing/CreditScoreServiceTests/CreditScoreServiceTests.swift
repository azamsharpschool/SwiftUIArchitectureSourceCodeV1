//
//  CreditScoreServiceTests.swift
//  CreditScoreServiceTests
//
//  Created by Mohammad Azam on 2/26/25.
//

import Testing
@testable import OuluBankR1

struct CreditScoreServiceTests {

    @Test
    func credit_score_service_returns_score_for_valid_ssn() async throws {
        
        let ssn = "123-45-6789" // credit score 720
        
        let creditScoreService = CreditScoreService()
        let creditScore = try await creditScoreService.getCreditScore(ssn: ssn)
        
        guard let creditScore = creditScore,
              let score = creditScore.score
        else {
            Issue.record("CreditScoreService did not respond with correct credit score.")
            return
        }
        
        #expect(score == 720)
    }
    
    @Test
    func credit_score_service_returns_no_credit_score_for_invalid_ssn() async throws {
        
        let ssn = "211-11-1111" // no credit score exists for this ssn
        
        let creditScoreService = CreditScoreService()
        let creditScore = try await creditScoreService.getCreditScore(ssn: ssn)
        
        guard let creditScore = creditScore
        else {
            Issue.record("CreditScoreService did not respond with correct credit score.")
            return
        }
        
        #expect(creditScore.score == nil)
        
    }

}
