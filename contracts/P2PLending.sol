// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./LoanRequest.sol";
import "./LoanOffer.sol";
import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";

contract P2PLending {
  using SafeMath for uint256;

  struct Loan {
    uint256 id;
    address borrower;
    address lender;
    uint256 amount;
    uint256 interestRate;
    uint256 duration;
    uint256 repaidAmount;
    uint256 repaymentCount;
    bool isPrepaymentApproved;
    address payer;
    uint256 prepaymentAmount;
    uint256 timestamp;
  }

  mapping(uint256 => Loan) public loans;
  uint256 public nextLoanId;

  LoanRequest public loanRequest;
  LoanOffer public loanOffer;

  constructor() public {
    loanRequest = new LoanRequest();
    loanOffer = new LoanOffer();
  }

  function createLoan(uint256 _requestId, uint256 _offerId, uint256 _amount, uint256 _interestRate, uint256 _duration) public {
    uint256 id = nextLoanId.add(1);
    loans[id] = Loan(id, loanRequest.loanRequests[_requestId].borrower, loanOffer.loanOffers[_offerId].lender, _amount, _interestRate, _duration, 0, 0, false);
    loanRequest.acceptLoanRequest(_requestId);
    loanOffer.acceptLoanOffer(_offerId);
    nextLoanId = id;
  }

  function viewLoan(uint256 _id) public view returns (uint256, address, address, uint256, uint256, uint256, uint256, uint256, bool) {
    Loan storage loan = loans[_id];
    return (loan.id, loan.borrower, loan.lender, loan.amount, loan.interestRate, loan.duration, loan.repaidAmount, loan.repaymentCount, loan.isPrepaymentApproved);
  }

  function markRepaymentReceived(uint256 _id) public payable {
    Loan storage loan = loans[_id];
    require(loan.repaidAmount.add(msg.value) <= loan.amount, "Exceeded total loan amount");
    loan.repaidAmount = loan.repaidAmount.add(msg.value);
    loan.repaymentCount = loan.repaymentCount.add(1);
    loan.lender.transfer(msg.value);
  }

  function makeRepayment(uint256 _id, uint256 _amount) public payable {
    Loan storage loan = loans[_id];
    require(_amount <= loan.amount.sub(loan.repaidAmount), "Exceeded remaining loan amount");
    require(loan.duration > 0, "Loan has already been fully repaid");
    markRepaymentReceived(_id);
    loan.duration = loan.duration.sub(1);
  }

  function makePrepayment(uint256 _id, uint256 _amount) public payable {
  Loan storage loan = loans[_id];
  require(loan.repaidAmount == 0, "Cannot make prepayment on loan with unpaid balance");
  require(_amount <= loan.amount, "Exceeded total loan amount");
  require(loan.duration > 0, "Loan has already been fully repaid");
  require(loan.isPrepaymentApproved == false, "Prepayment has already been approved");
  loan.borrower.transfer(_amount);
  loan.isPrepaymentApproved = true;
 }

 function approvePrepayment(uint256 _id) public {
  Loan storage loan = loans[_id];
  require(loan.isPrepaymentApproved == true, "Prepayment not found or already approved");
  require(loan.duration > 0, "Loan has already been fully repaid");
  loan.amount = loan.amount.sub(loan.repaidAmount);
  loan.repaidAmount = 0;
  loan.repaymentCount = 0;
  loan.duration = loan.duration.sub(1);
  loan.isPrepaymentApproved = false;
 }

 function refinanceLoan(uint256 _id, uint256 _amount, uint256 _interestRate, uint256 _duration) public {
  Loan storage loan = loans[_id];
  require(loan.repaidAmount == 0, "Cannot refinance loan with unpaid balance");
  require(_amount <= loan.amount, "Exceeded total loan amount");
  require(_duration > loan.duration, "New loan duration must be longer than the current one");
  loan.amount = _amount;
  loan.interestRate = _interestRate;
  loan.duration = _duration;
 }

 function cancelLoan(uint256 _id) public {
  Loan storage loan = loans[_id];
  require(loan.repaidAmount == 0, "Cannot cancel loan with unpaid balance");
  delete loans[_id];
 }

  // Mapping from loan request ID to loan ID
  mapping(uint256 => uint256) public loanRequestIdToLoanId;

  // Returns the ID of the loan created from the given loan request ID
 function getLoanIdFromLoanRequestId(uint256 _loanRequestId) public view returns (uint256) {
  return loanRequestIdToLoanId[_loanRequestId];
 }

  // Mapping from loan offer ID to loan ID
  mapping(uint256 => uint256) public loanOfferIdToLoanId;

  // Returns the ID of the loan created from the given loan offer ID
 function getLoanIdFromLoanOfferId(uint256 _loanOfferId) public view returns (uint256) {
  return loanOfferIdToLoanId[_loanOfferId];
 }

  // Mapping from loan ID to loan request ID
  mapping(uint256 => uint256) public loanIdToLoanRequestId;

  // Returns the loan request ID of the given loan ID
 function getLoanRequestIdFromLoanId(uint256 _loanId) public view returns (uint256) {
  return loanIdToLoanRequestId[_loanId];
 }

  // Mapping from loan ID to loan offer ID
  mapping(uint256 => uint256) public loanIdToLoanOfferId;

  // Returns the loan offer ID of the given loan ID
 function getLoanOfferIdFromLoanId(uint256 _loanId) public view returns (uint256) {
  return loanIdToLoanOfferId[_loanId];
 }

  // Mapping from borrower address to list of loan IDs
  mapping(address => uint256[]) public borrowerToLoans;

  // Returns a list of the loan IDs for loans taken out by the given borrower
 function getLoansByBorrower(address _borrower) public view returns (uint256[]) {
  return borrowerToLoans[_borrower];
 }

  // Mapping from lender address to list of loan IDs
  mapping(address => uint256[]) public lenderToLoans;

  // Returns a list of the loan IDs for loans given by the given lender
 function getLoansByLender(address _lender) public view returns (uint256[]) {
  return lenderToLoans[_lender];
 }

  // Mapping from loan ID to list of repayment IDs
  mapping(uint256 => uint256[]) public loanIdToRepayments;

  // Returns a list of the repayment IDs for the given loan ID
 function getRepaymentsByLoanId(uint256 _loanId) public view returns (uint256[]) {
  return loanIdToRepayments[_loanId];
 }

  // Mapping from borrower address to list of repayment IDs
  mapping(address => uint256[]) public borrowerToRepayments;

  // Returns a list of the repayment IDs for repayments made by the given borrower
 function getRepaymentsByBorrower(address _borrower) public view returns (uint256[]) {
  return borrowerToRepayments[_borrower];
 }

  // Mapping from lender address to list of repayment IDs
  mapping(address => uint256[]) public lenderToRepayments;

  // Returns a list of the repayment IDs for repayments received by the given lender
 function getRepaymentsByLender(address _lender) public view returns (uint256[]) {
  return lenderToRepayments[_lender];
 }
  // Mapping from prepayment ID to prepayment data
  mapping(uint256 => Prepayment) public prepayments;

  // Returns the data for the given prepayment ID
 function getPrepayment(uint256 _id) public view returns (uint256, uint256, address, address, uint256, bool, bool) {
  Prepayment storage prepayment = prepayments[_id];
  return (prepayment.id, prepayment.loanId, prepayment.borrower, prepayment.lender, prepayment.amount, prepayment.isCompleted, prepayment.isApproved);
 }

  // Mapping from loan ID to list of refinance IDs
  mapping(uint256 => uint256[]) public loanIdToRefinances;

  // Returns a list of the refinance IDs for the given loan ID
 function getRefinancesByLoanId(uint256 _loanId) public view returns (uint256[]) {
  return loanIdToRefinances[_loanId];
 }

  // Mapping from borrower address to list of refinance IDs
  mapping(address => uint256[]) public borrowerToRefinances;

  // Returns a list of the refinance IDs for refinances requested by the given borrower
 function getRefinancesByBorrower(address _borrower) public view returns (uint256[]) {
  return borrowerToRefinances[_borrower];
 }

  // Mapping from lender address to list of refinance IDs
  mapping(address => uint256[]) public lenderToRefinances;

  // Returns a list of the refinance IDs for refinances received by the given lender
 function getRefinancesByLender(address _lender) public view returns (uint256[]) {
  return lenderToRefinances[_lender];
 }
  // Mapping from loan ID to default data
  mapping(uint256 => Default) public defaults;

  // Returns the data for the given default ID
 function getDefault(uint256 _id) public view returns (uint256, uint256, address, address, uint256, bool) {
  Default storage defaults = defaults[_id];
  return (defaults.id, defaults.loanId, defaults.borrower, defaults.lender, defaults.amount, defaults.isCompleted);
 }

  // Mapping from loan ID to list of default IDs
  mapping(uint256 => uint256[]) public loanIdToDefaults;

  // Returns a list of the default IDs for the given loan ID
 function getDefaultsByLoanId(uint256 _loanId) public view returns (uint256[]) {
  return loanIdToDefaults[_loanId];
 }

  // Mapping from borrower address to list of default IDs
  mapping(address => uint256[]) public borrowerToDefaults;

  // Returns a list of the default IDs for defaults caused by the given borrower
 function getDefaultsByBorrower(address _borrower) public view returns (uint256[]) {
  return borrowerToDefaults[_borrower];
 }

  // Mapping from lender address to list of default IDs
  mapping(address => uint256[]) public lenderToDefaults;

  // Returns a list of the default IDs for defaults received by the given lender
 function getDefaultsByLender(address _lender) public view returns (uint256[]) {
  return lenderToDefaults[_lender];
 }
   function refinanceLoan(uint256 _id, uint256 _amount, uint256 _interestRate, uint256 _duration) public {
    Loan storage loan = loans[_id];
    require(loan.repaidAmount == 0, "Cannot refinance loan with unpaid balance");
    require(loan.duration > 0, "Loan has already been fully repaid");
    require(loan.borrower == msg.sender, "Only the borrower can refinance the loan");
    // Update the loan with the new details
    loan.amount = _amount;
    loan.interestRate = _interestRate;
    loan.duration = _duration;
    loan.repaidAmount = 0;
    loan.repaymentCount = 0;
    loan.isPrepaymentApproved = false;
  }
}
