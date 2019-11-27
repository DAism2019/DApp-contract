pragma solidity ^0.5.0;
import "./IDappMethodInfo.sol";
import "./IDappHubGet.sol";

contract DappMethodInfo is IDappMethodInfo {

    struct MethodInfo {
        address to;
        bool isPayable;
        uint value;
        string infos;       // inclue name | description | params | params_demo
        bytes data;
        bool isHidden;
    }

    IDappHubGet public dapp_hub;
    mapping(uint => MethodInfo[]) public allStoreMethodInfos;  // storeId => MethodInfo[]

    modifier validIndex(uint storeId,uint index) {
        require(index < allStoreMethodInfos[storeId].length,"DappMethodInfo: global index out of bounds");
        _;
    }

    modifier onlyMethodAdmin {
        require(msg.sender == dapp_hub.getMethodAdminAddress(),"DappMethodInfo:permission denied");
        _;
    }

    constructor(address dapp_hub_address) public {
        require(dapp_hub_address != address(0),"DappMethodInfo: zero_address");
        dapp_hub = IDappHubGet(dapp_hub_address);
    }

    // get the count of methods in a store
    function getStoreMethodCount(uint storeId) external view returns(uint) {
        return allStoreMethodInfos[storeId].length;
    }

    function getMethodInfoByIndex(uint storeId,uint index) external view  validIndex(storeId,index) returns(address,bool,uint,string memory,bytes memory,bool) {
        MethodInfo memory method_infos = allStoreMethodInfos[storeId][index];
        return (method_infos.to,method_infos.isPayable,method_infos.value,method_infos.infos,method_infos.data,method_infos.isHidden);
    }

    function addMethod(uint storeId,address to,bool isPayable,uint eth_value,string calldata infos,bytes calldata data) external onlyMethodAdmin {
        require(to != address(0),"DappMethodInfo: zero_address");
        MethodInfo memory method_infos = MethodInfo(to,isPayable,eth_value,infos,data,false);
        allStoreMethodInfos[storeId].push(method_infos);
    }

    function updateMethodInfos(uint storeId,uint index,string calldata infos) external validIndex(storeId,index) onlyMethodAdmin {
        allStoreMethodInfos[storeId][index].infos = infos;
    }

    function updateMethodValue(uint storeId,uint index,uint new_value) external validIndex(storeId,index) onlyMethodAdmin {
        allStoreMethodInfos[storeId][index].value = new_value;
    }

    function hideMethod(uint storeId,uint index) external validIndex(storeId,index) onlyMethodAdmin {
        require(!allStoreMethodInfos[storeId][index].isHidden,"DappMethodInfo: the method has been frozen");
        allStoreMethodInfos[storeId][index].isHidden = true;
    }

    function showMethod(uint storeId,uint index) external validIndex(storeId,index) onlyMethodAdmin {
        require(allStoreMethodInfos[storeId][index].isHidden,"DappMethodInfo: the method has been frozen");
        allStoreMethodInfos[storeId][index].isHidden = false;
    }

    function removeMethod(uint storeId,uint index) external validIndex(storeId,index) onlyMethodAdmin {
        uint finalIndex = allStoreMethodInfos[storeId].length - 1;
        if(index < finalIndex) {
            allStoreMethodInfos[storeId][index] = allStoreMethodInfos[storeId][finalIndex];
        }
        allStoreMethodInfos[storeId].length = finalIndex;
    }

}
