from contract import DappStoreAdmin,DappStoreInfo,Test
from privateKey import my_address, private_key
from web3.auto import w3
import time


ONE_ETHER = 10 ** 18


def getInfo():
    nonce = DappStoreInfo.functions.nonce().call()
    print("当前共有",nonce,"个DAPP")
    for i in range(nonce):
        infos = DappStoreInfo.functions.allStoreInfos(i+1).call()
        print("当前DAPP信息为:")
        print("创建者:",infos[0])
        print("DAPP地址:",infos[1])
        print("ID:",infos[2])
        timestamp = time.localtime(infos[3])
        otherStyleTime = time.strftime("%Y--%m--%d %H:%M:%S", timestamp)
        print("创建时间:",otherStyleTime)
        print("名称:",infos[4])
        print("描述:",infos[5])
        print("标签:",infos[6])
        print("网址:",infos[7])
        print("-------------------")


def getFee():
    fee = DappStoreAdmin.functions.getRegisterFee().call()
    print("当前注册DAPP的服务费为:",fee/ONE_ETHER,"ETH")
    return fee


def register():
    fee = getFee()
    args = (Test.address,"TestDapp","This is a TestDapp","test","https://localhost")
    nonce = w3.eth.getTransactionCount(my_address)
    unicorn_txn = DappStoreAdmin.functions.registerDappStore(*args).buildTransaction({
        'nonce': nonce,
        'value':fee,
        'gasPrice': w3.toWei(10, 'gwei'),
    })
    signed_txn = w3.eth.account.signTransaction(
        unicorn_txn, private_key=private_key)
    hash = w3.eth.sendRawTransaction(signed_txn.rawTransaction)
    print("注册交易已经发送")


getInfo()
register()
getInfo()
