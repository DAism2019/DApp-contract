pragma solidity ^0.5.0;
import "./IDappHubGet.sol";

contract DappStoreInfo {
    struct StoreInfo {
        address creator;
        address store;
        uint id;
        uint createTime;
        string name;
        string description;
        string label;
        string website;
    }
    IDappHubGet public dapp_hub;           //instance of DappHub
    uint public nonce;                                      // id of store
    mapping(uint => StoreInfo) public allStoreInfos;        // id => StoreInfo
    mapping(address => uint) public storeId;          // store_address => id
    mapping(string => uint[])  private _storeByLabel;             //classify by label   lable => id[]
    mapping(address => uint[]) private _storeByUser;              // classify by creator creator => id[]
    mapping(string => uint) private _storeIdByName;         // record name has been registered or not

    modifier onlyStoreAdmin {
        require(msg.sender == dapp_hub.getStoreAdminAddress(),"DappStoreInfo:permission denied");
        _;
    }

    constructor(address dapp_hub_address) public {
        require(dapp_hub_address != address(0),"DappStoreInfo: zero_address");
        dapp_hub = IDappHubGet(dapp_hub_address);
    }

    function isRegistered(address store) external view returns(bool) {
        return storeId[store] != 0;
    }

    function isNameRigstered(string calldata name) external view returns(bool) {
        return _storeIdByName[name] != 0;
    }

    function _checkValid( address creator,address store,string memory name ) private view {
        require(creator != address(0) && store != address(0),"DappStoreInfo: zero_address");
        require(storeId[store] == 0,"DappStoreInfo: store has been registered");
        require(_storeIdByName[name] == 0,"DappStoreInfo: name has been registered");
    }

    function registerDappStore(address creator, address store,string calldata name,string calldata description,
            string calldata label,string calldata website) external onlyStoreAdmin returns(uint) {
        _checkValid(creator,store,name);
        nonce ++;
        allStoreInfos[nonce] = StoreInfo(creator,store,nonce,block.timestamp,name,description,label,website);
        storeId[store] = nonce;
        _storeIdByName[name] = nonce;
        _storeByLabel[label].push(nonce);
        _storeByUser[creator].push(nonce);
        return nonce;
    }

 /////////////////////////////// implement enumable ////////////////////////////////
    // enumable by creator
    function getUserStoreCount(address creator) external view returns(uint) {
        return _storeByUser[creator].length;
    }

    function getUserStoreIdByIndex(address creator,uint index) external view returns(uint) {
        require(index < _storeByUser[creator].length,"DappStoreInfo: global index out of bounds");
        return _storeByUser[creator][index];
    }

    function getUserStoreInfoByIndex(address creator,uint index) external view returns(address,address,uint,uint,string memory,string memory ,string memory) {
        /**
        * @param creator the creator to classify
        * @param index the index of id array that classified by creator
        * @return creator、address、id、createTime、name、description、label of store
        */
        require(index < _storeByUser[creator].length,"DappStoreInfo: global index out of bounds");
        uint id = _storeByUser[creator][index];
        return _getStoreInfoById(id);
    }

    // enumable by label
    function getLabelStoreCount(string calldata label) external view returns(uint) {
        return _storeByLabel[label].length;
    }

    function getLabelStoreIdByIndex(string calldata label,uint index) external view returns(uint) {
        require(index < _storeByLabel[label].length,"DappStoreInfo: global index out of bounds");
        return _storeByLabel[label][index];
    }

    function getLabelStoreInfoByIndex(string calldata label,uint index) external view returns(address,address,uint,uint,string memory,string memory ,string memory) {
        /**
        * @param label the label to classify
        * @param index the index of id array that classified by label
        * @return creator、address、id、createTime、name、description、label of store
        */
        require(index < _storeByLabel[label].length,"DappStoreInfo: global index out of bounds");
        uint id = _storeByLabel[label][index];
        return _getStoreInfoById(id);
    }

    //enumable by name
    function getStoreIdByName(string calldata name) external view returns(uint) {
        return _storeIdByName[name];
    }

    function getStoreInfoByName(string calldata name) external view returns(address,address,uint,uint,string memory,string memory ,string memory) {
        /**
        * @param name the name to store
        * @return creator、address、id、createTime、name、description、label of store
        */
        uint id = _storeIdByName[name];
        return _getStoreInfoById(id);
    }

    function _getStoreInfoById(uint id) private view returns(address,address,uint,uint,string memory,string memory ,string memory) {
        StoreInfo memory infos = allStoreInfos[id];
        return (infos.creator,infos.store,infos.id,infos.createTime,infos.name,infos.description,infos.label);
    }

    //get creator by store id
    function getStoreCreatorById(uint id) external view returns(address) {
        return allStoreInfos[id].creator;
    }

}
