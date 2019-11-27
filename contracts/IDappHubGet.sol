pragma solidity ^0.5.0;

interface IDappHubGet {
    function getStoreAdminAddress() external view returns(address);
    function getRegisterFee() external view returns(uint);
    function getMethodAdminAddress() external view returns(address);
    function getBeneficiary() external view returns(address payable);
}
