// SPDX-License-Identifier: non-open-source
pragma solidity >=0.6.0 <0.8.0;

contract Counter {
    int256 private count = 0;
    
    address private _owner;
    
    function incrementCounter() public {
        count += 10;
    }

    function decrementCounter() public {
        count -= 1;
    }

    function getCount() public view returns (int256) {
        return count;
    }

    function getOwner() public view returns (address) {
        
        return _owner;
    }

    function setOwner(address owner) public {
        _owner = owner;
    }

    function jumpTo(int256 to) public {
        count = to;        
    }    
}