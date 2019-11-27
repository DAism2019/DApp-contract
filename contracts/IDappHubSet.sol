pragma solidity ^0.5.0;

interface IDappHubSet {
    function setStoreAdminAddress(address new_address) external;
    function setRegisterFee(uint new_fee) external;
    function setBeneficiary(address payable new_beneficiary) external;
    function setMethodAdminAddress(address new_address) external;
}
