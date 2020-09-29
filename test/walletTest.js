const Wallet = artifacts.require('Wallet'); 
const Fund = artifacts.require('Fund');

contract('Wallet', (accounts) => {

    let fund;
    let fundAddress;
    let wallet;
    let walletAddress;

    const eitherValue = (value) => {
        return web3.utils.toWei(value, "ether");
    }
    
    let addToken = async () => {

        // add two ether to fund 
        await web3.eth.sendTransaction({from: accounts[0], to: fundAddress, 
            value: eitherValue("2")});
   
        // add two ether to wallet
        await web3.eth.sendTransaction({from: accounts[0], to: walletAddress, 
            value: eitherValue("2")});
    }; 

    let cleanFund = async () => {

        // get the balance from address
        const remainingBalance = await web3.eth.getBalance(fundAddress);
        
        await fund.withdraw(accounts[0], remainingBalance);            
    }

    let cleanWallet = async () => {

        // get the balance from address
        const remainingBalance = await web3.eth.getBalance(walletAddress);
        
        await wallet.withdraw(accounts[0], remainingBalance);
    }

    let getBN = (wei) => {

        return web3.utils.toBN(wei);
    } 

    beforeEach(async () => {

        fund = await Fund.deployed();
        fundAddress = await fund.address;
        wallet = await Wallet.deployed();
        walletAddress = await wallet.address;

        await addToken();
    });

    afterEach(async () => {

        await cleanFund();
        await cleanWallet();
    });

    // verify the owner of the wallet is the user deployed it
    it('should have owner as the first account', async () => {
        const owner = await wallet.getOwner();
        assert.equal(owner, accounts[0]);
    });

    // verify that the smart contract can receive ECR20 token
    it('should receive token', async () => {

        const balanceBefore = await wallet.getBalance();
        
        // transfer token to the smart contract first from accounts[0]        
        await web3.eth.sendTransaction({from: accounts[0], to: walletAddress, 
                value: eitherValue("1")});

        const balanceAfter = await wallet.getBalance();

        const expectBN = balanceBefore.add(getBN(eitherValue("1"))); 

        assert.equal(balanceAfter.toString(), expectBN.toString(), "wallet transfer is not correct");        
    });

    it('should donate from wallet to fund', async () => {

        // donate from wallet to fund
        const walletBalanceBefore = await wallet.getBalance();
        const fundBalanceBefore = await fund.getBalance();

        await wallet.donate(fundAddress, eitherValue("1"));
        const walletBalanceAfter = await wallet.getBalance();
        const fundBalanceAfter = await fund.getBalance();

        const wallectExpected = walletBalanceAfter.add(getBN(eitherValue("1")));
        const fundExpected = fundBalanceBefore.add(getBN(eitherValue("1")));

        assert.equal(walletBalanceBefore.toString(), wallectExpected.toString(), "wallet donate is not correct");
        assert.equal(fundBalanceAfter.toString(), fundExpected.toString(), "fund transfer is not correct");
    });

    it('should consume fund', async () => {

        await cleanWallet();
        
        // donate from wallet to fund
        const walletBalanceBefore = await wallet.getBalance();
        const fundBalanceBefore = await fund.getBalance();

        const walletBalanceStr = walletBalanceBefore.toString();
        const fundBalanceStr = fundBalanceBefore.toString();

        await wallet.consume(fundAddress, eitherValue("1"));
        const walletBalanceAfter = await wallet.getBalance();
        const fundBalanceAfter = await fund.getBalance();

        const wallectExpected = walletBalanceBefore.add(getBN(eitherValue("1")));
        const fundExpected = fundBalanceAfter.add(getBN(eitherValue("1")));

        // wallet balance increases afterwards
        assert.equal(walletBalanceAfter.toString(), wallectExpected.toString(), "wallet donate is not correct");
        // fund balance reduces afterwards
        assert.equal(fundBalanceBefore.toString(), fundExpected.toString(), "fund transfer is not correct");
    });
});