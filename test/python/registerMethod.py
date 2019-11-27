from contract import DappMethodAdmin,DappMethodInfo,Test
from privateKey import my_address, private_key
from web3.auto import w3

DAPP_ID = 1
ONE_ETHER = 10 ** 18


def getInfo():
    count = DappMethodInfo.functions.getStoreMethodCount(DAPP_ID).call()
    print("当前DAPP的方法数量为:",count)
    for i in range(count):
        infos = DappMethodInfo.functions.getMethodInfoByIndex(DAPP_ID,i).call()
        print("索引为%d当前方法信息为:"%i)
        print("当前方法调用合约地址:",infos[0])
        print("当前方法是否可支付ETH:",infos[1])
        print("当前方法支付的ETH最小数量:",infos[2]/ONE_ETHER)
        print("当前方法的一些信息:",infos[3])
        print("当前方法的默认编码数据:",infos[4])
        print("当前方法是否可见:",not infos[5])
        print("--------------------------------------")


def addMethod():
    args = (DAPP_ID,Test.address,False,0,"registerName|User register his name|string|none",b'')
    nonce = w3.eth.getTransactionCount(my_address)
    unicorn_txn = DappMethodAdmin.functions.addMethod(*args).buildTransaction({
        'nonce': nonce,
        'gasPrice': w3.toWei(10, 'gwei'),
    })
    signed_txn = w3.eth.account.signTransaction(
        unicorn_txn, private_key=private_key)
    hash = w3.eth.sendRawTransaction(signed_txn.rawTransaction)
    print("增加方法交易已经发送")


getInfo()
addMethod()
getInfo()
