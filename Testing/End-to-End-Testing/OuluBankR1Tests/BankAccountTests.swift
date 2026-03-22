//
//  OuluBankR1Tests.swift
//  OuluBankR1Tests
//
//  Created by Mohammad Azam on 2/13/25.
//

import Testing
@testable import OuluBankR1

struct BankAccountTests {

    @Test(arguments: [DepositType.check, DepositType.cash])
    func deposit_amount_using_check_or_cash_increases_balance(_ depositType: DepositType) {
        // ARRANGE
        let bankAccount = BankAccount(accountNumber: "123456", balance: 500)
        
        // ACT
        try? bankAccount.deposit(amount: 200, depositType: depositType)
        
        // ASSERT 
        #expect(bankAccount.balance == 700)
    }
    
    @Test
    func depositing_using_transfer_type_charges_fee() {
        
        let bankAccount = BankAccount(accountNumber: "123456", balance: 500)
        
        let depositAmount = 200.0
        let expectedBalance = 696.0
        
        try? bankAccount.deposit(amount: depositAmount, depositType: .transfer)
        #expect(bankAccount.balance == expectedBalance)
    }
    
    @Test
    func depositing_negative_amount_results_in_invalid_amount_error() {
        
        let bankAccount = BankAccount(accountNumber: "123456", balance: 500)
        
        #expect(throws: BankAccountError.invalidAmount, "Depositing negative amount did not throw an error.", performing: {
            try bankAccount.deposit(amount: -10, depositType: .cash)
        })
    }
    
    @Test
    func withdrawing_amount_decreases_balance() {
        let bankAccount = BankAccount(accountNumber: "123456", balance: 500)
        bankAccount.withdraw(amount: 200, withdrawType: .check)
        #expect(bankAccount.balance == 300)
    }
    
    @Test
    func withdrawing_with_insufficient_balance_results_in_penalty() {
        
        let bankAccount = BankAccount(accountNumber: "123456", balance: 500)
        
        bankAccount.withdraw(amount: 600, withdrawType: .check)
        
        #expect(bankAccount.balance == 490)
    }
    
    @Test
    func depositing_amount_is_added_to_transaction_history() {
        
        let bankAccount = BankAccount(accountNumber: "123456", balance: 500)
        
        try? bankAccount.deposit(amount: 10, depositType: .check)
        
        #expect(bankAccount.transactions.count == 1, "Transactions was not increment after deposit.")
        #expect(bankAccount.transactions[0].amount == 10, "Transaction amount is not matching.")
        #expect(bankAccount.transactions[0].transactionType == TransactionType.deposit, "Transaction type is not matching.")
    }
}
