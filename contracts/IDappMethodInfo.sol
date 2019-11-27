pragma solidity ^0.5.0;
interface IDappMethodInfo {
    function addMethod(uint storeId,address to,bool isPayable,uint eth_value,string calldata infos,bytes calldata data) external;
    function updateMethodInfos(uint storeId,uint index,string calldata infos) external;
    function updateMethodValue(uint storeId,uint index,uint new_value) external;
    function hideMethod(uint storeId,uint index) external;
    function showMethod(uint storeId,uint index) external;
    function removeMethod(uint storeId,uint index) external;
}
