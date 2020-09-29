const Fund = artifacts.require('Fund');

contract('Fund', (accounts) => {

    let fund; 
    let fundAddress;

    let getBN = (wei) => {

        return web3.utils.toBN(wei);
    } 

    beforeEach(async () => {
        fund = await Fund.deployed();
        fundAddress = await fund.address;
        console.log(`contract address: ${fundAddress}`);
    });

    // verify that the fund contract can receive ERC20 Token
    it('should receive token', async () => {

        const balanceBefore = await fund.getBalance();
        
        const eitherValue = web3.utils.toWei("1", "ether");
        
        // transfer token to the smart contract first from accounts[0]        
        await web3.eth.sendTransaction({from: accounts[0], to: fundAddress, 
                value: eitherValue});

        const balanceAfter = await fund.getBalance();

        const expectBN = balanceBefore.add(getBN(eitherValue)); 

        assert.equal(balanceAfter.toString(), expectBN.toString(),  
                "transferring does not correct");        
    });

    
})