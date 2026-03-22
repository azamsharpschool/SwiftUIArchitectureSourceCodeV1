//
//  APRService.swift
//  OuluBankR1
//
//  Created by Mohammad Azam on 2/15/25.
//

import Foundation

enum CreditScoreServiceError: LocalizedError {
    case noCreditScoreFound
    case unavailable
    
    // Provide localized error descriptions
    var errorDescription: String? {
        switch self {
            case .noCreditScoreFound:
                return NSLocalizedString(
                    "No credit score was found for the provided SSN.",
                    comment: "Error message when no credit score is found."
                )
            case .unavailable:
                return NSLocalizedString(
                    "Credit score is unavailable or not applicable for the given SSN.",
                    comment: "Credit score is unavailable or not applicable for the given SSN."
                )
        }
    }
}

enum APRServiceError: Error {
    case invalidSSN 
}

struct APRService {
    
    // third party service
    let creditScoreService: CreditScoreServiceProtocol
    
    func getAPR(ssn: String) async throws -> Double {
        
        // check if ssn is valid or not
        if !ssn.isSSN {
            throw APRServiceError.invalidSSN
        }
        
        guard let creditScore = try await creditScoreService.getCreditScore(ssn: ssn) else {
            throw CreditScoreServiceError.noCreditScoreFound
        }
        
        if let score = creditScore.score {
            if score > 650 {
                return Double.random(in: 1...3)
            } else {
                return Double.random(in: 6...10)
            }
        } else {
            throw CreditScoreServiceError.unavailable
        }
    }
    
}


