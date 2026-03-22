//
//  APRRequestScreen.swift
//  OuluBankR1UITests
//
//  Created by Mohammad Azam on 3/3/25.
//

import Foundation
import XCTest

class APRRequestScreen {
    
    let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
        self.app.launchArguments = ["UITEST"]
        self.app.launch()
    }
    
    private lazy var ssnTextField: XCUIElement = {
        let textField = app.textFields["ssnTextField"]
        return textField
    }()
    
    private lazy var calculateAPRButton: XCUIElement = {
        let calculateAPRButton = app.buttons["calculateAPRButton"]
        return calculateAPRButton
    }()
    
    private lazy var aprText: XCUIElement = {
        let aprText = app.staticTexts["aprText"]
        return aprText
    }()
    
    private lazy var messageText: XCUIElement = {
        let messageText = app.staticTexts["messageText"]
        return messageText
    }()
    
    func aprTextExists(timeout: TimeInterval = 5.0) -> Bool {
        aprText.waitForExistence(timeout: timeout)
    }
    
    func messageTextExists(timeout: TimeInterval = 5.0) -> Bool {
        messageText.waitForExistence(timeout: timeout)
    }
    
    func getAPRText() -> String {
        aprText.label
    }
    
    func getMessageText() -> String {
        messageText.label 
    }
    
    func enterSSN(_ text: String) -> Self {
        ssnTextField.tap()
        ssnTextField.typeText(text)
        return self
    }
    
    @discardableResult
    func tapCalculateAPRButton() -> Self {
        calculateAPRButton.tap()
        return self
    }
    
}
