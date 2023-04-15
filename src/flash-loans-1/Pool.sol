// SCH Course Copyright Policy (C): DO-NOT-SHARE-WITH-ANYONE
// https://smartcontractshacking.com/#copyright-policy
pragma solidity ^0.8.13;

interface IReceiver {
    function getETH() external payable;
}

contract Pool {
    constructor() payable {}

    // TODO: Complete this function
    function flashLoan(uint256 amount) external {
        uint256 balanceBefore = address(this).balance;
        require(balanceBefore >= amount, "Not Enough ETH");
        IReceiver(msg.sender).getETH{value: amount}();
        require(address(this).balance >= balanceBefore, "Flashloan not paid back!!!");
    }

    receive() external payable {}
}
