## Description

A Lending Marketplace provides a secure, flexible, open-source foundation for a decentralized loan marketplace on the Ethereum blockchain. It provides the pieces necessary to create a decentralized lending exchange, including the requisite lending assets, repayments, and collateral infrastructure, enabling third parties to build applications for lending.

Generally, a Crypto lending marketplace is usually a decentralized exchange where a loan can be offered in Crypto and repayments can be made in different ERC20 tokens (say DAI, MATIC, LINK, etc). In this application, there are two main features like creating a ‘loan request’ by the Borrower on the marketplace where other funders can check and fund the loan as per requirements. Similarly, a Lender can also create a ‘loan offer’ which can be later accepted by the Borrower on the marketplace. There will be monthly repayments on the loan which the borrower can repay in the selected ERC20 token. In case the loan has defaulted i.e. repayment misses then the collateral submitted by the borrower will go to the Lender and if all repayments are paid successfully then collateral will be returned to the Borrower.

## Functions / UI Methods 

**Loan request**

This function is a request from the borrower, the user who is asking for a loan. It includes the loan amount and duration; interest the user is willing to pay; data about the collateral such as the collateral address & collateral amount; the cryptocurrency being requested as a loan; price of the collateral in the specific cryptocurrency & finally the loan contract address.

```
function createNewLoanRequest(uint256 _loanAmount, uint128 _duration, uint256 _interest, address _collateralAddress, uint256 _collateralAmount, uint256 _collateralPriceInETH)
 public returns(address _loanContractAddress) {

         _loanContractAddress = address (new LoanContract(_loanAmount, _duration, "", _interest, _collateralAddress, _collateralAmount, _collateralPriceInETH, 50, msg.sender, address(0), LoanContract.LoanStatus.REQUEST));

         loans.push(_loanContractAddress);

         emit LoanRequestCreated(msg.sender, _loanContractAddress);

         return _loanContractAddress;
 }
 ```

**Loan offer**

Taking input from the user who wants to loan their cryptocurrency, this function will include the loan amount, duration, data about the collateral accepted in case the loan isn’t paid, referencing the same to the loan contract address.

```
function createNewLoanOffer(uint256 _loanAmount, uint128 _duration, string memory _acceptedCollateralsMetadata) public returns(address _loanContractAddress) {

         _loanContractAddress = address (new LoanContract(_loanAmount, _duration, _acceptedCollateralsMetadata, 0, address(0), 0, 0, 0, address(0), msg.sender, LoanContract.LoanStatus.OFFER));

         loans.push(_loanContractAddress);

         emit LoanOfferCreated(msg.sender, _loanContractAddress);

         return _loanContractAddress;
```         

## Available Scripts

**Install dependencies:**

`yarn install`

In the project directory, you can run:

`yarn start`

Runs the app in the development mode.<br>
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

## Author

 [Dev Yadav](https://github.com/devilla)
