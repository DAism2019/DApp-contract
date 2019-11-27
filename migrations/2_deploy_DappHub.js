const DappHub = artifacts.require("DappHub");

module.exports = function(deployer) {
  deployer.deploy(DappHub);
};
