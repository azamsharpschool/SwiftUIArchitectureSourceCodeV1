//
//  OuluBankR1UITests.swift
//  OuluBankR1UITests
//
//  Created by Mohammad Azam on 2/15/25.
//

import XCTest

final class OuluBankR1UITests: XCTestCase {
    
    var app: XCUIApplication!
    var screen: APRRequestScreen!
    
    override func setUp() {
        app = XCUIApplication()
        screen = APRRequestScreen(app: app)
    }
    
    func test_user_can_calculate_apr_successfully_with_valid_ssn() {
        
        screen
            .enterSSN("123-45-6789")
            .tapCalculateAPRButton()
        
        XCTAssertTrue(screen.aprTextExists())
        XCTAssertNotEqual(screen.getAPRText(), "", "APR text should not be empty.")
    }
    
    func test_displays_error_message_when_credit_score_was_not_found_for_ssn() {
        
        let expectedErrorMessage = "No credit score was found for the provided SSN."
        
        screen
            .enterSSN("211-11-1111")
            .tapCalculateAPRButton()
        
        
        XCTAssertTrue(screen.messageTextExists(), "Message text should not be empty.")
        XCTAssertEqual(screen.getMessageText(), expectedErrorMessage)
        
    }
    
 
}
