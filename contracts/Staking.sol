pragma solidity ^0.5.4;

import "./DappToken.sol";
import "./DaiToken.sol";

contract Staking {

  string public name= "Ya Bank";
  DappToken public dappToken;
  DaiToken public daiToken;
  address public owner;

  address[] public stakers;
  mapping(address => uint) public stakingBalance;
  mapping(address => bool) public hasStaked;
  mapping(address => bool) public isStaking;

  constructor(DappToken _dappToken, DaiToken _daiToken) public {
     dappToken = _dappToken;
     daiToken = _daiToken;
     owner = msg.sender;
  }

  function stakeTokens(uint _amount) public{

    require(_amount > 0, "amount cannot be 0");
    daiToken.transferFrom(msg.sender, address(this), _amount);

    stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;
    
    if(!hasStaked[msg.sender]) {
      stakers.push(msg.sender);
    }

    isStaking[msg.sender] = true;
    hasStaked[msg.sender] = true;
  }

  function issueTokens() public {
    require(msg.sender == owner, "caller must be the owner");
    for (uint i=0; i<stakers.length; ++i){
      address recipient = stakers[i];
      uint balance = stakingBalance[recipient];
      if(balance > 0) {
        dappToken.transfer(recipient, balance);
      }
    }
  }

  function unstakeTokens() public {
    uint balance = stakingBalance[msg.sender];
    require(balance > 0, "balance cannot be 0");

    daiToken.transfer(msg.sender, balance);

    stakingBalance[msg.sender] = 0;
    isStaking[msg.sender] = false;
  }
}