// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Referral{
    address public owner;
    
    struct Node {
        address addr;
        address parent;
        bytes32[] nodes;
        uint level;
    }
    
    uint public depositLevels;
    uint public interestLevels;
    
    mapping(address => Node) public users;
    
    mapping(uint => uint) public interestCommission;
    mapping(uint => uint) public depositCommission;
    
    mapping(address => uint) public commissions;
    
    Node[] public topLevels;
    
    constructor() {
        owner = msg.sender;
        depositLevels = 0;
        interestLevels = 0;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function toBytes(address _addr) public pure returns(bytes32){
        return bytes32(uint256(uint160(_addr)) << 96);
    }
    
    function addInterestLevel(uint _commission) public onlyOwner{
        interestCommission[++interestLevels] = _commission;
    }
    
    function addDepositLevel(uint _commission) public onlyOwner{
        depositCommission[++depositLevels] = _commission;
    }
    
    function addUser(address _parent) public {
        
        users[msg.sender]=Node({
            addr: msg.sender,
            parent: _parent,
            nodes: new bytes32[](0),
            level: 0
        });
        if(_parent == address(0)){
            topLevels.push(users[msg.sender]);
        }else{
            Node storage parentNode = users[_parent];
            users[msg.sender].level = parentNode.level+1;
            parentNode.nodes.push(toBytes(msg.sender));
        }
    } 
    
    function distributeInterestCommissions(uint _interest, address _addr) public {
        Node memory node = users[_addr];
        address parent = node.parent;
        require(parent != address(0));
        Node memory parentNode = users[parent];
        while(parent != address(0) && node.level - parentNode.level <= interestLevels){
            uint currLevel = node.level - parentNode.level;
            commissions[parent] += uint(_interest*interestCommission[currLevel]/uint(100));
            parent = parentNode.parent;
            parentNode = users[parent];
        }
        
    }
    
    function distributeDepositCommissions(uint _deposit, address _addr) public {
        Node memory node = users[_addr];
        address parent = node.parent;
        require(parent != address(0));
        Node memory parentNode = users[parent];
        while(parent != address(0) && node.level - parentNode.level <= depositLevels){
            uint currLevel = node.level - parentNode.level;
            commissions[parent] += uint(_deposit*depositCommission[currLevel]/uint(100));
            parent = parentNode.parent;
            parentNode = users[parent];
        }
    }
    
    
    function removeUser(address _addr) public {
        Node memory node = users[_addr];
        require(node.parent == msg.sender);
        delete users[_addr];
        Node storage parentNode = users[node.parent];
        for(uint i=0; i < parentNode.nodes.length; ++i){
            if(parentNode.nodes[i] == toBytes(_addr)){
                delete parentNode.nodes[i];
                break;
            }
        }
        //TODO
    }
}