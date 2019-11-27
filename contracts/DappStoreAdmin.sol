pragma solidity ^0.5.0;
/**
*   This contract can be upgrade
*/
import "./Ownable.sol";
import "./IDappHubGet.sol";

contract DappStoreInfoInterface {
    function registerDappStore(address creator, address store,string calldata name,string calldata description,
        string calldata label,string calldata website) external returns(uint);
}

contract DappStoreAdmin {
    DappStoreInfoInterface  public dapp_info;       //instance of DappStoreInfo
    IDappHubGet public dapp_hub;                    //instance of DappHub

    event RegisterDappSuc(address indexed creator,address indexed store,uint id,string name);

    constructor(address dapp_hub_address,address dapp_info_address) public {
        require(dapp_hub_address != address(0) && dapp_info_address != address(0),"DappStoreAdmin: zero_address");
        dapp_hub = IDappHubGet(dapp_hub_address);
        dapp_info = DappStoreInfoInterface(dapp_info_address);
    }

    //return the fee of registering a dapp
    function getRegisterFee() external view returns(uint) {
        return dapp_hub.getRegisterFee();
    }

    function registerDappStore(address store,string calldata name,string calldata description,string calldata label,string calldata website) external payable {
        /**
            @dev Register a Dapp which must implement the owner() method;
            @param store The address of Dapp
            @param name The name of Dapp
            @param description The description of Dapp
            @param label The label of Dapp
        */
        _check_pay(msg.value);
        address store_owner = Ownable(store).owner();
        require(store_owner == msg.sender,"DappStoreAdmin: dapp must be registered by its owner");
        uint id = dapp_info.registerDappStore(msg.sender,store,name,description,label,website);
        emit RegisterDappSuc(msg.sender,store,id,name);
    }

    function _check_pay(uint eth_value) private {
        uint fee = dapp_hub.getRegisterFee();
        require(eth_value >= fee,'DappStoreAdmin: insufficient ethers');
        address payable beneficiary = dapp_hub.getBeneficiary();
        if(fee > 0){
            require(beneficiary != address(0),"DappStoreAdmin: transfer ethers to zero_address");
            beneficiary.transfer(eth_value);
        }
    }
}
