pragma solidity ^0.5.0;
import "./IDappMethodInfo.sol";

contract StoreInfoInterface {
    function getStoreCreatorById(uint id) external view returns(address);
}

contract DappMethodAdmin is IDappMethodInfo {
    IDappMethodInfo public method_info;         //instance of DappMethodInfo
    StoreInfoInterface public store_info;       //instance of DappStoreInfo

    event AddOneMethodSuc(address indexed creator,uint indexed storeId);
    event UpdateMethodSuc(address indexed creator,uint indexed storeId,uint indexed index);
    event UpdateMethodVisibleSuc(address indexed creator,uint indexed storeId,uint indexed index,bool isHidden);
    event RemoveMethodSuc(address indexed creator,uint indexed storeId,uint indexed index);


    constructor(address method_info_address,address store_info_address) public {
        require(method_info_address != address(0) && store_info_address != address(0),"DappMethodAdmin: zero_address");
        method_info = IDappMethodInfo(method_info_address);
        store_info = StoreInfoInterface(store_info_address);
    }

    modifier onlyStoreCreator(uint storeId) {
        address store_creator = store_info.getStoreCreatorById(storeId);
        require(store_creator != address(0) && store_creator == msg.sender);
        _;
    }

   function addMethod(uint storeId,address to,uint eth_value,string calldata infos,bytes calldata data) external onlyStoreCreator(storeId) {
        method_info.addMethod(storeId,to,eth_value,infos,data);
        emit AddOneMethodSuc(msg.sender,storeId);
    }

    function updateMethodInfos(uint storeId,uint index,string calldata infos) external onlyStoreCreator(storeId) {
        method_info.updateMethodInfos(storeId,index,infos);
        emit UpdateMethodSuc(msg.sender,storeId,index);
    }

    function updateMethodValue(uint storeId,uint index,uint new_value) external onlyStoreCreator(storeId) {
        method_info.updateMethodValue(storeId,index,new_value);
        emit UpdateMethodSuc(msg.sender,storeId,index);
    }

    function hideMethod(uint storeId,uint index) external onlyStoreCreator(storeId) {
        method_info.hideMethod(storeId,index);
        emit UpdateMethodVisibleSuc(msg.sender,storeId,index,true);
    }

    function showMethod(uint storeId,uint index) external onlyStoreCreator(storeId) {
        method_info.showMethod(storeId,index);
        emit UpdateMethodVisibleSuc(msg.sender,storeId,index,false);
    }

    function removeMethod(uint storeId,uint index) external onlyStoreCreator(storeId) {
        method_info.removeMethod(storeId,index);
        emit RemoveMethodSuc(msg.sender,storeId,index);
    }
}
