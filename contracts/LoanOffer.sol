// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";

contract LoanOffer {
  using SafeMath for uint256;

  // Data structure for storing the details of a loan offer
  struct LoanOfferData {
    uint256 id;
    address borrower;
    address lender;
    uint256 amount;
    uint256 repaymentAmount;
    uint256 interestRate;
    uint256 duration;
    bool isAccepted;
    bool repaymentReceived;
    bool prepaymentRequested;
    bool prepaymentApproved;
    bool prepaymentReceived;
    uint256 remainingBalance;
  }

  // Mapping from loan offer ID to loan offer data
  mapping(uint256 => LoanOfferData) public loanOffers;
  // ID of the next loan offer
  uint256 public nextLoanOfferId;

  // Creates a new loan offer
  function createLoanOffer(address _borrower, address _lender, uint256 _amount, uint256 _interestRate, uint256 _duration) public {
    uint256 id = nextLoanOfferId.add(1);
    loanOffers[id] = LoanOfferData(id, _borrower, _lender, _amount, _amount, _interestRate, _duration, false, false, false, false, false, _amount);
    nextLoanOfferId = id;
  }

    // Returns the data for a specific loan offer
  function viewLoanOffer(uint256 _id) public view returns (uint256, address, address, uint256, uint256, uint256, bool, bool, bool, bool, bool, uint256) {
    LoanOfferData storage loanOffer = loanOffers[_id];
    return (loanOffer.id, loanOffer.borrower, loanOffer.lender, loanOffer.amount, loanOffer.interestRate, loanOffer.duration, loanOffer.isAccepted, loanOffer.repaymentReceived, loanOffer.prepaymentRequested, loanOffer.prepaymentApproved, loanOffer.prepaymentReceived, loanOffer.remainingBalance);
  }

  // Accepts a loan offer
  function acceptLoanOffer(uint256 _id) public {
    // Check that the loan offer with the given ID exists
    require(loanOffers[_id].id != 0, "Loan offer not found");
    // Check that the current user is the borrower for the loan offer
    require(loanOffers[_id].borrower == msg.sender, "Only the borrower can accept the loan offer");
    // Check that the loan offer has not already been accepted
    require(loanOffers[_id].isAccepted == false, "Loan offer has already been accepted");
    loanOffers[_id].isAccepted = true;
  }

  // Marks a repayment as received
  function markRepaymentReceived(uint256 _id) public payable {
    // Check that the loan offer with the given ID exists
    require(loanOffers[_id].id != 0, "Loan offer not found");
    // Check that the loan offer has been accepted
    require(loanOffers[_id].isAccepted == true, "Loan offer has not been accepted");
    // Check that the current user is the lender for the loan offer
    require(loanOffers[_id].lender == msg.sender, "Only the lender can mark a repayment as received");
    // Check that the borrower has sent the required amount of Ether
    require(msg.value == loanOffers[_id].repaymentAmount, "Invalid Ether amount");
    // Check that the repayment has not already been received
    require(loanOffers[_id].repaymentReceived == false, "Repayment has already been received");
    // Update the remaining balance of the loan
    loanOffers[_id].remainingBalance = loanOffers[_id].remainingBalance.sub(loanOffers[_id].repaymentAmount);
    // Mark the repayment as received
    loanOffers[_id].repaymentReceived = true;
  }

    // Requests a prepayment
  function requestPrepayment(uint256 _id) public {
    // Check that the loan offer with the given ID exists
    require(loanOffers[_id].id != 0, "Loan offer not found");
    // Check that the loan offer has been accepted
    require(loanOffers[_id].isAccepted == true, "Loan offer has not been accepted");
    // Check that the current user is the borrower for the loan offer
    require(loanOffers[_id].borrower == msg.sender, "Only the borrower can request a prepayment");
    // Check that a prepayment has not already been requested
    require(loanOffers[_id].prepaymentRequested == false, "Prepayment has already been requested");
    loanOffers[_id].prepaymentRequested = true;
  }

  // Approves a prepayment
  function approvePrepayment(uint256 _id) public {
    // Check that the loan offer with the given ID exists
    require(loanOffers[_id].id != 0, "Loan offer not found");
    // Check that the loan offer has been accepted
    require(loanOffers[_id].isAccepted == true, "Loan offer has not been accepted");
    // Check that a prepayment has been requested
    require(loanOffers[_id].prepaymentRequested == true, "No prepayment requested");
    // Check that the current user is the lender for the loan offer
    require(loanOffers[_id].lender == msg.sender, "Only the lender can approve a prepayment");
    loanOffers[_id].prepaymentApproved = true;
  }

    // Marks a prepayment as received
  function markPrepaymentReceived(uint256 _id) public {
    // Check that the loan offer with the given ID exists
    require(loanOffers[_id].id != 0, "Loan offer not found");
    // Check that the loan offer has been accepted
    require(loanOffers[_id].isAccepted == true, "Loan offer has not been accepted");
    // Check that a prepayment has been requested
    require(loanOffers[_id].prepaymentRequested == true, "No prepayment requested");
    // Check that a prepayment has been approved
    require(loanOffers[_id].prepaymentApproved == true, "Prepayment has not been approved");
    // Check that the current user is the lender for the loan offer
    require(loanOffers[_id].lender == msg.sender, "Only the lender can mark a prepayment as received");
    // Check that the prepayment has not already been received
    require(loanOffers[_id].prepaymentReceived == false, "Prepayment has already been received");
    loanOffers[_id].prepaymentReceived = true;
    loanOffers[_id].remainingBalance = loanOffers[_id].remainingBalance.sub(loanOffers[_id].remainingBalance);
  }
}


 
