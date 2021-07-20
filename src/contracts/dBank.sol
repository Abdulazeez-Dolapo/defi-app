// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "./Token.sol";

contract dBank {

  //assign Token contract to variable
  Token private token; 

  //add mappings
  mapping (address => uint) public etherBalanceOf;
  mapping (address => uint) public depositStart;
  mapping (address => bool) public isDeposited;

  //add events
  event Deposit(address indexed user, uint etherAmount, uint timeStart);
  event Withdraw(address indexed user, uint etherAmount, uint totalDepositTime, uint interest);

  //pass as constructor argument deployed Token contract
  constructor(Token _token) public {
    //assign token deployed contract to variable
    token = _token;
  }

  function deposit() payable public {
    //check if msg.sender didn't already deposit funds
    require(isDeposited[msg.sender] == false, "Error: Deposit already active.");
    //check if msg.value is >= 0.01 ETH
    require(msg.value >= 10**16, 'Error: Only deposit of 0.01 ETH and above is allowed');

    //increase msg.sender ether deposit balance
    etherBalanceOf[msg.sender] = etherBalanceOf[msg.sender] + msg.value;
    //start msg.sender hodling time
    depositStart[msg.sender] = depositStart[msg.sender] + block.timestamp;
    //set msg.sender deposit status to true
    isDeposited[msg.sender] = true; 
    //emit Deposit event
    emit Deposit(msg.sender, msg.value, block.timestamp); 
  }

  function withdraw() public {
    //check if msg.sender deposit status is true
    require(isDeposited[msg.sender] == true, "Error: No previous deposit.");
    //assign msg.sender ether deposit balance to variable for event
    uint userBalance = etherBalanceOf[msg.sender];

    //check user's hodl time
    uint depositTime = block.timestamp - depositStart[msg.sender];

    // calc interest per second
    // Interest is calculated at 10% per year
    uint NUMBER_OF_SECONDS_PER_YEAR = 365.25 * 24 * 60 * 60;
    uint tenPercentOfUserBalance = (userBalance * 1e15) / 1e16;
    uint interestPerSecond = tenPercentOfUserBalance / NUMBER_OF_SECONDS_PER_YEAR;

    //calc accrued interest
    uint interest = depositTime * interestPerSecond;

    //send eth to user
    msg.sender.transfer(userBalance);

    //send interest in tokens to user
    token.mint(msg.sender, interest);

    //reset depositer data
    etherBalanceOf[msg.sender] = 0;
    depositStart[msg.sender] = 0;
    isDeposited[msg.sender] = false; 

    //emit Withdraw event
    emit Withdraw(msg.sender, userBalance, depositTime, interest);
  }

  function borrow() payable public {
    //check if collateral is >= than 0.01 ETH
    //check if user doesn't have active loan

    //add msg.value to ether collateral

    //calc tokens amount to mint, 50% of msg.value

    //mint&send tokens to user

    //activate borrower's loan status

    //emit event
  }

  function payOff() public {
    //check if loan is active
    //transfer tokens from user back to the contract

    //calc fee

    //send user's collateral minus fee

    //reset borrower's data

    //emit event
  }
}