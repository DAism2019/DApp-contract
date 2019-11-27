pragma solidity ^0.5.0;
import "./Ownable.sol";

contract Test is Ownable {
    mapping(address => uint) public allDeposits;
    mapping(address => string) public usernames;

    function transferEther() payable external {
        allDeposits[msg.sender] += msg.value;
    }

    function withDraw() external {
        uint value = allDeposits[msg.sender];
        allDeposits[msg.sender] = 0;
        msg.sender.transfer(value);
    }

    function registerName(string calldata name) external {
        usernames[msg.sender] = name;
    }
   
}
