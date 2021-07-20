// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
  //add minter variable
  address public minter;

  //add minter changed event
  event MinterChanged(address indexed from, address to);

  constructor() public payable ERC20("AZ meme currency", "AZM") {
    //asign initial minter
    minter = msg.sender;
  }

  //Add pass minter role function
  function passMinterRole(address dBank) public returns (bool) {
    //check if the sender is the minter
    require(msg.sender == minter, 'Error: Only owner can change pass minter role');
    //set the new minter
    minter = dBank;
    //emit the minter changed event
    emit MinterChanged(msg.sender, dBank);
    return true;
  }

  function mint(address account, uint256 amount) public {
    require(msg.sender == minter, 'Error: Only minter can mint tokens.');
		_mint(account, amount);
	}
}