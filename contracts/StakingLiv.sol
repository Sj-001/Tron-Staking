pragma solidity ^0.5.0;

import "./LivToken.sol";
// import "./DaiToken.sol";

contract Staking {

  LivToken public livToken;
  address public owner;

  address[] public stakers;
  mapping(address => uint) public stakingBalance;
  mapping(address => bool) public hasStaked;
  mapping(address => bool) public isStaking;
  mapping(address => uint) public rewards;

  constructor(LivToken _livToken) public {
     livToken = _livToken;
     owner = msg.sender;
  }

  function stakeTokens(uint _amount) public{

    require(_amount > 0, "amount cannot be 0");
    livToken.transferFrom(msg.sender, address(this), _amount);

    stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;
    
    if(!hasStaked[msg.sender]) {
      stakers.push(msg.sender);
    }

    isStaking[msg.sender] = true;
    hasStaked[msg.sender] = true;
  }

  function stakeOf(address _stakeholder)
        public
        view
        returns(uint)
    {
        return stakes[_stakeholder];
    }

  function calculateReward(uint apy, address stakeHolder){
    rewards[stakeHolder] = stakingBalance[stakeHolder]*apy/100;
  }

  function distributeRewards() 
        public
        
    {
        require(msg.sender == owner);
        for (uint s = 0; s < stakers.length; s += 1){
            address stakeholder = stakers[s];
            uint reward = calculateReward(stakeholder);
            rewards[stakeholder] = rewards[stakeholder].add(reward);
        }
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
        uint reward = rewards[msg.sender];
        rewards[msg.sender] = 0;
        livToken._mint(msg.sender, reward);
    }

  function unstakeTokens() public {
    uint balance = stakingBalance[msg.sender];
    require(balance > 0, "balance cannot be 0");

    livToken.transfer(msg.sender, balance);

    stakingBalance[msg.sender] = 0;
    isStaking[msg.sender] = false;
  }
}