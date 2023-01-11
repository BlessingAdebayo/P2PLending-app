// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";

// This contract defines the struct and functions for loan requests
contract LoanRequest {
  using SafeMath for uint256;
  
  // struct to store the loan request data
  struct LoanRequestData {
    uint256 id;
    address borrower;
    address lender;
    uint256 amount;
    uint256 interestRate;
    uint256 duration;
    bool isAccepted;
    uint256 remainingBalance;
  }

  // Mapping to store the loan requests
  mapping(uint256 => LoanRequestData) public loanRequests;
  // variable to track the next loan request ID
  uint256 public nextLoanRequestId;

  // Function to create a new loan request
  function createLoanRequest(address _borrower, address _lender, uint256 _amount, uint256 _interestRate, uint256 _duration) public {
    uint256 id = nextLoanRequestId.add(1);
    // Create a new loan request and add it to the mapping
    loanRequests[id] = LoanRequestData(id, _borrower, _lender, _amount, _interestRate, _duration, false, _amount);
    nextLoanRequestId = id;
  }

  // Function to view a loan request
  function viewLoanRequest(uint256 _id) public view returns (uint256, address, address, uint256, uint256, uint256, bool) {
    LoanRequestData storage loanRequest = loanRequests[_id];
    // Return the details of the loan request
    return (loanRequest.id, loanRequest.borrower, loanRequest.lender, loanRequest.amount, loanRequest.interestRate, loanRequest.duration, loanRequest.isAccepted);
  }

  // Function to accept a loan request
  function acceptLoanRequest(uint256 _id) public {
    // Check that the loan request with the given ID exists
    require(loanRequests[_id].id != 0, "Loan request not found");
    // Check that the loan request has not already been accepted
    require(loanRequests[_id].isAccepted == false, "Loan request already accepted");
    // Check that the current user is the lender for the loan request
    require(loanRequests[_id].lender == msg.sender, "Only the lender can accept the loan request");

    // Set the isAccepted field of the loan request struct to true
    loanRequests[_id].isAccepted = true;
  }

  // Function to make a repayment
  function makeRepayment(uint256 _id, uint256 _amount) public {
    // Check that the loan request with the given ID exists
    require(loanRequests[_id].id != 0, "Loan request not found");
    // Check that the loan request has been accepted
    require(loanRequests[_id].isAccepted == true, "Loan request has not been accepted");
        // Check that the current user is the borrower for the loan request
    require(loanRequests[_id].borrower == msg.sender, "Only the borrower can make loan repayments");
    // Check that the repayment amount is greater than 0
    require(_amount > 0, "Invalid repayment amount");
    // Check that the repayment amount is not greater than the remaining balance
    require(_amount <= loanRequests[_id].remainingBalance, "Repayment amount exceeds remaining balance");

    // Subtract the repayment amount from the remaining balance
    loanRequests[_id].remainingBalance -= _amount;
  }

  // Function to mark a repayment as received
  function markRepaymentReceived(uint256 _id) public view{
    // Check that the loan request with the given ID exists
    require(loanRequests[_id].id != 0, "Loan request not found");
    // Check that the loan request has been accepted
    require(loanRequests[_id].isAccepted == true, "Loan request has not been accepted");
    // Check that the current user is the lender for the loan request
    require(loanRequests[_id].lender == msg.sender, "Only the lender can mark loan repayments as received");

    // Mark the repayment as received
    // (You can add code here to update a field in the loanRequest struct to track the status of the repayment)
  }

  // Function to cancel a loan request
  function cancelLoanRequest(uint256 _id) public {
    // Check that the loan request with the given ID exists
    require(loanRequests[_id].id != 0, "Loan request not found");
   // Check that the loan request has not already been accepted
    require(loanRequests[_id].isAccepted == false, "Cannot cancel an already accepted loan request");
    //Check that the user cancelling the loan request is the borrower
    require(loanRequests[_id].borrower == msg.sender, "Only the borrower can cancel the loan request");

    // delete the loan request from the mapping
    delete loanRequests[_id];
  }
}

