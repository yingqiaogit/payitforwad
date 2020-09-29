// SPDX-License-Identifier: non-open-source
pragma solidity >=0.6.0 <0.8.0;

// This is a contract for donation fund account
// The address deployed the contract is the 
// funding account
// Donation is for adding fund to this account
// Redeem is for releasing fund from this account
contract FundLean {

    address public owner; 

    event Receive(address indexed _from, uint256 _value); 
    event Consume(address indexed _to, uint256 _value);
    event Withdraw(address indexed _to, uint256 _value);

    constructor() public {
        owner = msg.sender;
    }

    modifier isOwner() {
        require (address(msg.sender) == owner);
        _;
    }

    modifier sufficient(uint256 amount) {
        require(address(this).balance >= amount);
        _;
    }

    modifier limited(address to, uint256 amount) {
        require(to.balance < amount);
        _;
    }

    receive () external payable {
        emit Receive(msg.sender, msg.value);
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function consume(address payable to, uint256 amount) public sufficient(amount) 
                            limited(to, amount) payable {
        
        to.transfer(amount);
        emit Consume(to, amount);
    }

    // withdraw fund to owner
    function withdraw(address payable to, uint256 amount) public sufficient(msg.value) isOwner payable {
        
        require(to == owner);
        to.transfer(amount);
        emit Withdraw(to, amount);
    }

}