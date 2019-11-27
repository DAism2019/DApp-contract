from web3.auto import w3
from json import loads
from os.path import dirname, abspath


def init():
    path = dirname(dirname(dirname(abspath(__file__))))
    all_address_path = path + '/test/address.json'
    all_address = loads(open(all_address_path).read())

    dapp_hub_abi_path = path + '/build/contracts/DappHub.json'
    store_info_abi_path = path + '/build/contracts/DappStoreInfo.json'
    method_info_abi_path = path + '/build/contracts/DappMethodInfo.json'
    store_admin_abi_path = path + '/build/contracts/DappStoreAdmin.json'
    method_admin_abi_path = path + '/build/contracts/DappMethodAdmin.json'
    test_abi_path = path + '/build/contracts/DappMethodAdmin.json'


    contract_dapp_hub_abi = loads(open(dapp_hub_abi_path).read())['abi']
    contract_store_info_abi = loads(
        open(store_info_abi_path).read())['abi']
    contract_method_info_abi = loads(
        open(method_info_abi_path).read())['abi']
    contract_store_admin_abi = loads(
        open(store_admin_abi_path).read())['abi']
    contract_method_admin_abi = loads(
        open(method_admin_abi_path).read())['abi']
    contract_test_abi = loads(open(test_abi_path).read())['abi']

    contract_dapp_hub = w3.eth.contract(
        address=all_address["DappHub"], abi=contract_dapp_hub_abi)
    contract_store_info = w3.eth.contract(
        address=all_address["DappStoreInfo"], abi=contract_store_info_abi)
    contract_method_info = w3.eth.contract(
        address=all_address["DappMethodInfo"], abi=contract_method_info_abi)
    contract_store_admin = w3.eth.contract(
        address=all_address["DappStoreAdmin"], abi=contract_store_admin_abi)
    contract_method_admin = w3.eth.contract(
        address=all_address["DappMethodAdmin"], abi=contract_method_admin_abi)
    contract_test = w3.eth.contract(
        address=all_address["Test"], abi=contract_test_abi)

    return contract_dapp_hub, contract_store_info, contract_method_info, contract_store_admin,contract_method_admin,contract_test


DappHub, DappStoreInfo, DappMethodInfo, DappStoreAdmin,DappMethodAdmin,Test = init()
