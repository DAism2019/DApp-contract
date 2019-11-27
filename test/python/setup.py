from contract import DappHub,DappStoreAdmin,DappMethodAdmin
from privateKey import my_address, private_key
from web3.auto import w3

ONE_ETHER = 10 ** 18
ANOTHER_ADDRESS = '0x8Df5B73CD52AC4837e761277a3C769f7F50A0cd2'

def getInfo():
    isUpgrade = DappHub.functions.isUpgrade().call()
    print("当前合约是否升级过:",isUpgrade)
    if isUpgrade:
        instance = DappHub.functions.instance().call()
        print("当前合约升级后的地址为:",instance)
    beneficiary = DappHub.functions.getBeneficiary().call()
    print("当前服务费汇聚地址为:",beneficiary)
    fee = DappHub.functions.getRegisterFee().call()
    print("当前注册DAPP的服务费为:",fee/ONE_ETHER,"ETH")
    store_admin = DappHub.functions.getStoreAdminAddress().call()
    print("当前StoreAdmin合约的地址为:",store_admin)
    method_admin = DappHub.functions.getMethodAdminAddress().call()
    print("当前method_admin合约的地址为:",method_admin)


def setStoreAdminAddress():
    nonce = w3.eth.getTransactionCount(my_address)
    unicorn_txn = DappHub.functions.setStoreAdminAddress(DappStoreAdmin.address).buildTransaction({
        'nonce': nonce,
        'gasPrice': w3.toWei(10, 'gwei'),
    })
    signed_txn = w3.eth.account.signTransaction(
        unicorn_txn, private_key=private_key)
    hash = w3.eth.sendRawTransaction(signed_txn.rawTransaction)
    print("setStoreAdminAddress交易已经发送")


def setMethodAdminAddress():
    nonce = w3.eth.getTransactionCount(my_address)
    unicorn_txn = DappHub.functions.setMethodAdminAddress(DappMethodAdmin.address).buildTransaction({
        'nonce': nonce,
        'gasPrice': w3.toWei(10, 'gwei'),
    })
    signed_txn = w3.eth.account.signTransaction(
        unicorn_txn, private_key=private_key)
    hash = w3.eth.sendRawTransaction(signed_txn.rawTransaction)
    print("setMethodAdminAddress交易已经发送")

def setBeneficiary():
    nonce = w3.eth.getTransactionCount(my_address)
    unicorn_txn = DappHub.functions.setBeneficiary(ANOTHER_ADDRESS).buildTransaction({
        'nonce': nonce,
        'gasPrice': w3.toWei(10, 'gwei'),
    })
    signed_txn = w3.eth.account.signTransaction(
        unicorn_txn, private_key=private_key)
    hash = w3.eth.sendRawTransaction(signed_txn.rawTransaction)
    print("setBeneficiary交易已经发送")


def setRegisterFee():
    nonce = w3.eth.getTransactionCount(my_address)
    unicorn_txn = DappHub.functions.setRegisterFee(ONE_ETHER).buildTransaction({
        'nonce': nonce,
        'gasPrice': w3.toWei(10, 'gwei'),
    })
    signed_txn = w3.eth.account.signTransaction(
        unicorn_txn, private_key=private_key)
    hash = w3.eth.sendRawTransaction(signed_txn.rawTransaction)
    print("setRegisterFee交易已经发送")


def setup():
    setStoreAdminAddress()
    setMethodAdminAddress()
    setBeneficiary()
    setRegisterFee()

getInfo()
setup()
getInfo()
