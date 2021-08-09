// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./LivToken.sol";
import "./Referral.sol";
// import "./DaiToken.sol";

contract Staking is Referral{

  LivToken public livToken;

  address[] public stakers;
  mapping(address => uint) public stakingBalance;
  mapping(address => bool) public hasStaked;
  mapping(address => bool) public isStaking;
  mapping(address => uint) public rewards;

  constructor(LivToken _livToken) Referral(){
     livToken = _livToken;
     owner = msg.sender;
  }

  function stakeTokens(uint _amount, address _parent) public{

    require(_amount > 0, "amount cannot be 0");
    livToken.transferFrom(msg.sender, address(this), _amount);

    stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;
    
    if(!hasStaked[msg.sender]) {
      stakers.push(msg.sender);
    }
    addUser(_parent);
    distributeDepositCommissions(_amount, msg.sender);
    isStaking[msg.sender] = true;
    hasStaked[msg.sender] = true;
  }

  function stakeOf(address _stakeholder)
        public
        view
        returns(uint)
    {
        return stakingBalance[_stakeholder];
    }

  function calculateReward(uint apy, address stakeHolder) public {
    rewards[stakeHolder] += stakingBalance[stakeHolder]*apy/uint(100);
    distributeInterestCommissions(rewards[stakeHolder], stakeHolder);
  }

  
    function rewardOf(address _stakeholder) 
        public
        view
        returns(uint)
    {
        return rewards[_stakeholder];
    }

    function withdrawReward() 
        public
    {
        uint reward = rewards[msg.sender] + commissions[msg.sender];
        rewards[msg.sender] = 0;
        commissions[msg.sender] = 0;
        livToken.transfer(msg.sender, reward);
    }

  function unstakeTokens() public {
    uint balance = stakingBalance[msg.sender];
    require(balance > 0, "balance cannot be 0");

    livToken.transfer(msg.sender, balance);
    removeUser(msg.sender);
    stakingBalance[msg.sender] = 0;
    isStaking[msg.sender] = false;
  }
}