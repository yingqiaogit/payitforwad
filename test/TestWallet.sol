// SPDX-License-Identifier: non-open-source
pragma solidity >=0.6.0 <0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Wallet.sol";

contract TestWallet {

    function testConstructUsingDeployedContract() public {

        Wallet test = Wallet(DeployedAddresses.Wallet());

        Assert.equal(test.getOwner(), DeployedAddresses.Wallet(), 
                        "Owner should be setup");
    }
}


