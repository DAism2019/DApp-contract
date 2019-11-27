const fsService = require('../scripts/fileService');
const fileName = "./test/address.json";

const DappHub = artifacts.require("DappHub");
const DappStoreInfo = artifacts.require("DappStoreInfo");
const DappMethodInfo = artifacts.require("DappMethodInfo");
const DappStoreAdmin = artifacts.require("DappStoreAdmin");
const DappMethodAdmin = artifacts.require("DappMethodAdmin");
const Test = artifacts.require("Test");

const data = {
    "DappHub": DappHub.address,
    "DappStoreInfo": DappStoreInfo.address,
    "DappMethodInfo": DappMethodInfo.address,
    "DappStoreAdmin": DappStoreAdmin.address,
    "DappMethodAdmin": DappMethodAdmin.address,
    "Test":Test.address
}

module.exports = function(deployer) {
    fsService.writeJson(fileName, data);
    console.log('address save over');
};
