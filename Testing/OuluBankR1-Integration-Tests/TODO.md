
# Oulu Bank TODO 

## Bank Account Tests for Deposit and Withdraw (Unit Tests)

- (DONE) When deposit using check or cash then bank balance increases.  
- (DONE) When deposit using transfer then charge 2% fee to amount deposited.  
- (DONE) Depositing negative amount is not allowed. 
- (DONE) Withdrawing with insufficient balance results in penalty. 
- (DONE) Deposited amount is added to the transaction history. 
- Withdrawing the amount is added to the transaction history 

## APRService Tests 

- (DONE) APR is calculated within expected range for valid SSN.
- (DONE) APR calculation fails for ssn with no credit score.  

## Mocking

- (DONE) APR service should call get credit score on credit score service
- APR service does not call get credit score for invalid ssn   

## UITests 

- User can calculate APR successfully for valid SSN. 
- Displays error message when credit score was invalid or not found. 
