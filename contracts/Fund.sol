// SPDX-License-Identifier: non-open-source
pragma solidity >=0.6.0 <0.8.0;

// This is a contract for a fund account
// The address deployed the contract is the 
// funding account
// Donation is for adding fund to this account
// Redeem is for releasing fund from this account
contract Fund {

    address private _owner; 

    event Receive(address indexed _from, uint256 _value); 
    event Consume(address indexed _to, uint256 _value);
    event Withdraw(address indexed _to, uint256 _value);

    modifier isOwner(address forCheck) {
        require (address(forCheck) == _owner);
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

    receive () external payable {}
    
    function setOwner(address owner) public {
        _owner = owner;
    }

    function consume(address payable to, uint256 amount) public sufficient(amount) 
                            limited(to, amount) payable {
        
        to.transfer(amount);
        emit Consume(to, amount);
    }

    // withdraw fund to owner
    function withdraw(address payable to, uint256 amount) public sufficient(amount) isOwner(to) payable {
        
        to.transfer(amount);
        emit Withdraw(to, amount);
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function getOwner() public view returns (address) {
        return _owner;
    } 
}