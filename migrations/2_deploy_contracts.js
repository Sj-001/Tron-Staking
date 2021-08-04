// var MyContract = artifacts.require("./MyContract.sol");
const DappToken = artifacts.require("DappToken");
const DaiToken = artifacts.require("DaiToken");
const Staking = artifacts.require("Staking");

module.exports = async function (deployer) {
  // deployer.deploy(MyContract);
  await deployer.deploy(DaiToken);
  const daiToken = await DaiToken.deployed();

  // Deploy Dapp Token
  await deployer.deploy(DappToken);
  const dappToken = await DappToken.deployed();

  console.log(dappToken);

  // Deploy TokenFarm
  // await deployer.deploy(Staking, dappToken.address, daiToken.address);
};
