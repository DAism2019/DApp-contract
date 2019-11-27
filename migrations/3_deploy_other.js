const DappHub = artifacts.require("DappHub");
const DappStoreInfo = artifacts.require("DappStoreInfo");
const DappMethodInfo = artifacts.require("DappMethodInfo");

module.exports = function(deployer) {
  deployer.deploy(DappStoreInfo,DappHub.address);
  deployer.deploy(DappMethodInfo,DappHub.address);
};
