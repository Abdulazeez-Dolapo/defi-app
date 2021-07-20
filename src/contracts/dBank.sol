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
    //assign msg.sender ether deposit balance to variable for event

    //check user's hodl time

    //calc interest per second
    //calc accrued interest

    //send eth to user
    //send interest in tokens to user

    //reset depositer data

    //emit event
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