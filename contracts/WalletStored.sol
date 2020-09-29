// SPDX-License-Identifier: non-open-source
pragma solidity >=0.6.0 <0.8.0;
pragma experimental ABIEncoderV2;

import './Fund.sol';

contract WalletStored {

    address private _owner; 

    struct Promise {
        uint index;
        string name;
        uint256 amount;
    }
    
    mapping( string => Promise ) promises;
    string[] internal promiseNames;
    
    event Donate(address indexed _from, address indexed _to, uint256 amount);
    event Withdraw(address indexed _to, uint256 _value);

    modifier sufficient(uint256 amount) {
        require(address(this).balance >= amount);
        _;
    }

    modifier isOwner(address forCheck) {
        require (address(forCheck) == _owner);
        _;
    }

    receive () external payable {}

    function addPromise(string memory name, uint256 amount) internal {

        promises[name] = Promise(promiseNames.length, name, amount);

        promiseNames.push(name);
    }

    function removePromise(string memory name) internal {
        
        // get the index of the promises, 
        uint index = promises[name].index;

        // move the last one to the index, 
        uint lastIndex = promiseNames.length - 1; 
        promises[promiseNames[lastIndex]].index = index;
        string memory lastPromiseName = promiseNames[lastIndex];
        promiseNames[index] = lastPromiseName;
        promiseNames.pop();
    }

    function setOwner(address sender) external {
        _owner = sender;
    }

    // donate fund is to transfer fund to a donation Fund contract
    function donate(address from, address payable to, uint256 amount) 
        external isOwner(from) sufficient(amount)  payable {
        to.transfer(amount);
        emit Donate(from, to, amount);        
    }
    
    // consume fund from a Fund contract address
    function consume(address payable provider, address consumer, uint256 amount) 
            public payable isOwner(consumer) {
        Fund source = Fund(provider);
        source.consume(address(this), amount);        
    }

    // consume fund from a Fund contract address
    function consumeWithPromise(address payable provider, address consumer, uint256 amount, 
                            string memory promiseName, uint256 promiseAmount) 
            external payable isOwner(consumer)  {
        consume(provider, consumer, amount);
        addPromise(promiseName, promiseAmount);    
    }

    // withdraw token from wallet to owner
    function withdraw(address payable to, uint256 amount) external 
        isOwner(to) sufficient(amount) payable {
        to.transfer(amount);
        emit Withdraw(to, amount);
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function getOwner() public view returns(address) {
        return _owner;
    }

    function getPromises() public view returns(string[] memory) {

        string[] memory stored = new string[](promiseNames.length);

        for (uint i=0; i < promiseNames.length; i++) {

            stored[i] = promiseNames[i];
        }

        return stored;
    }
}