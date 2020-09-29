// SPDX-License-Identifier: non-open-source
pragma solidity >=0.6.0 <0.8.0;

import './FundLean.sol';

contract WalletLean {

    address public owner; 

    constructor() public {
        owner = msg.sender;
    }

    event Donate(address indexed _from, address indexed _to, uint256 amount);
    event Deposite(address indexed _owner, uint256 amount);
    event Withdraw(address indexed _to, uint256 _value);

    modifier sufficient() {
        require(address(this).balance >= msg.value);
        _;
    }

    modifier isOwner() {
        require (address(msg.sender) == owner);
        _;
    }

    receive () external payable {
        emit Deposite(msg.sender, msg.value);
    }

    // donate fund is to transfer fund to a donation Fund contract
    function donate(address payable to, uint256 amount) public sufficient isOwner payable {
        to.transfer(amount);
        emit Donate(msg.sender, to, amount);        
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function getOwner() public view returns(address) {
        return owner;
    }

    // consume fund from a smart contract address
    function consume(address payable from, uint256 amount) public payable isOwner returns(bool) {
        FundLean source = FundLean(from);
        source.consume(address(this), amount);
        return true;
    }

    // withdraw token from wallet to owner
    function withdraw(address payable to, uint256 amount) public 
        sufficient isOwner payable {
        
        require(to == owner);
        to.transfer(amount);
        emit Withdraw(to, amount);
    }
}

