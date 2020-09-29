const Wallet = artifacts.require("Wallet");
const Fund = artifacts.require("Fund");

module.exports = function(deployer) {
    deployer.deploy(Fund);
    deployer.deploy(Wallet);    
}