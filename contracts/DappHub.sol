pragma solidity ^0.5.0;
import "./IDappHubGet.sol";
import "./IDappHubSet.sol";
import "./Ownable.sol";

contract DappHub is Ownable,IDappHubGet, IDappHubSet {
    IDappHubGet public instance;                      //a new instance of self
    bool public isUpgrade;                          // has been upgraded
    address private store_admin_address;
    address private method_admin_address;
    uint private _registerFee;                        // the fee of registering a dapp
    address payable private _beneficiary;                   //address of beneficiary

    event UpgradeSuc(address to);
    event SetRegisterFeeSuc(uint fee);
    event SetStoreAdminAddressSuc(address old_address ,address new_address);
    event SetMethodAdminAddressSuc(address old_address ,address new_address);
    event setBeneficiarySuc(address old_address ,address new_address);

    modifier noZeroAddress(address _addrss) {
        require(_addrss != address(0),"WalletHub: zero_address");
        _;
    }

    function upgrade(address new_address) external noZeroAddress(new_address) onlyOwner {
        /**
            @dev Upgrade this contract
            @param new_address The address of new contract
        */
        isUpgrade = true;
        instance = IDappHubGet(new_address);
        emit UpgradeSuc(new_address);
    }

    function getStoreAdminAddress() external view returns(address) {
        /**
            @return The address of store_admin contract
        */
        if(isUpgrade) {
            return instance.getStoreAdminAddress();
        }else{
            return store_admin_address;
        }

    }

    function setStoreAdminAddress(address new_address) external noZeroAddress(new_address) onlyOwner {
        /**
            @dev Set the address of store_admin contract
            @param new_address The address of store_admin contract
        */
        emit SetStoreAdminAddressSuc(store_admin_address,new_address);
        store_admin_address = new_address;
    }

    function getMethodAdminAddress() external view returns(address) {
        /**
            @return The address of method_admin contract
        */
        if(isUpgrade) {
            return instance.getMethodAdminAddress();
        }else{
            return method_admin_address;
        }

    }

    function setMethodAdminAddress(address new_address) external noZeroAddress(new_address) onlyOwner {
        /**
            @dev Set the address of method_admin contract
            @param new_address The address of method_admin contract
        */
        emit SetMethodAdminAddressSuc(method_admin_address,new_address);
        method_admin_address = new_address;
    }


    function getRegisterFee() external view returns(uint) {
        /**
            @return The fee of registering a dapp
        */
        if(isUpgrade) {
            return instance.getRegisterFee();
        }else{
            return _registerFee;
        }
    }

    function setRegisterFee(uint new_fee) external onlyOwner {
        /**
            @dev Set the fee of registering a dapp
            @param newFee The new fee of registering a dapp
        */
        _registerFee = new_fee;
        emit SetRegisterFeeSuc(new_fee);
    }

    function getBeneficiary() external view returns(address payable) {
        /**
            @return The getBeneficiary
        */
        if(isUpgrade){
            return instance.getBeneficiary();
        }else{
            return _beneficiary;
        }
    }

    function setBeneficiary(address payable new_beneficiary) external noZeroAddress(new_beneficiary) onlyOwner {
        /**
            @dev Set the new  beneficiary
            @param new_beneficiary The address of new beneficiary
        */
        emit setBeneficiarySuc(_beneficiary,new_beneficiary);
        _beneficiary = new_beneficiary;
    }
}
