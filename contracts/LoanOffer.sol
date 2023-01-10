// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";

contract LoanOffer {
  using SafeMath for uint256;

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

  mapping(uint256 => LoanOfferData) public loanOffers;
  uint256 public nextLoanOfferId;

  function createLoanOffer(address _borrower, address _lender, uint256 _amount, uint256 _interestRate, uint256 _duration) public {
    uint256 id = nextLoanOfferId.add(1);
    loanOffers[id] = LoanOfferData(id, _borrower, _lender, _amount, _amount, _interestRate, _duration, false, false, false, false, false, _amount);
    nextLoanOfferId = id;
  }

  function viewLoanOffer(uint256 _id) public view returns (uint256, address, address, uint256, uint256, uint256, bool, bool, bool, bool, bool, uint256) {
    LoanOfferData storage loanOffer = loanOffers[_id];
    return (loanOffer.id, loanOffer.borrower, loanOffer.lender, loanOffer.amount, loanOffer.interestRate, loanOffer.duration, loanOffer.isAccepted, loanOffer.repaymentReceived, loanOffer.prepaymentRequested, loanOffer.prepaymentApproved, loanOffer.prepaymentReceived, loanOffer.remainingBalance);
  }

  function acceptLoanOffer(uint256 _id) public {
    // Check that the loan offer with the given ID exists
    require(loanOffers[_id].id != 0, "Loan offer not found");
    // Check that the current user is the borrower for the loan offer
    require(loanOffers[_id].borrower == msg.sender, "Only the borrower can accept the loan offer");
    // Check that the loan offer has not already been accepted
    require(loanOffers[_id].isAccepted == false, "Loan offer has already been accepted");
    loanOffers[_id].isAccepted = true;
  }

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

  

  function requestPrepayment(uint256 _id) public {
    // Check that the loan offer with the given ID exists
    require(loanOffers[_id].id != 0, "Loan offer not found");
    // Check that the loan offer has been accepted
    require(loanOffers[_id].isAccepted == true, "Loan offer has not been accepted");
    // Check that the current user is the borrower for the loan offer
    require(loanOffers[_id].borrower == msg.sender, "Only the borrower can request a prepayment");
    // Check that the borrower has not already requested a prepayment
    require(loanOffers[_id].prepaymentRequested == false, "Prepayment has already been requested");
    // Mark the prepayment as requested
    loanOffers[_id].prepaymentRequested = true;
  }

  function approvePrepayment(uint256 _id) public {
    // Check that the loan offer with the given ID exists
    require(loanOffers[_id].id != 0, "Loan offer not found");
    // Check that the loan offer has been accepted
    require(loanOffers[_id].isAccepted == true, "Loan offer has not been accepted");
    // Check that the current user is the lender for the loan offer
    require(loanOffers[_id].lender == msg.sender, "Only the lender can approve a prepayment");
    // Check that the borrower has requested a prepayment
    require(loanOffers[_id].prepaymentRequested == true, "Prepayment has not been requested");
    // Mark the prepayment as approved
    loanOffers[_id].prepaymentApproved = true;
  }

  function makePrepayment(uint256 _id, uint256 _amount) public {
    // Check that the loan offer with the given ID exists
    require(loanOffers[_id].id != 0, "Loan offer not found");
    // Check that the loan offer has been accepted
    require(loanOffers[_id].isAccepted == true, "Loan offer has not been accepted");
    // Check that the current user is the borrower for the loan offer
    require(loanOffers[_id].borrower == msg.sender, "Only the borrower can make a prepayment");
    // Check that the borrower has requested a prepayment
    require(loanOffers[_id].prepaymentRequested == true, "Prepayment has not been requested");
    // Check that the prepayment has been approved by the lender
    require(loanOffers[_id].prepaymentApproved == true, "Prepayment has not been approved");
    // Check that the given amount is greater than or equal to the remaining balance of the loan
    require(_amount >= (loanOffers[_id].remainingBalance), "Invalid prepayment amount");
    // Update the remaining balance of the loan
    loanOffers[_id].remainingBalance = loanOffers[_id].remainingBalance.sub(_amount);
    // Mark the prepayment as received
    loanOffers[_id].prepaymentReceived = true;
  }
}
