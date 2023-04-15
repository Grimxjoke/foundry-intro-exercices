// SCH Course Copyright Policy (C): DO-NOT-SHARE-WITH-ANYONE
// https://smartcontractshacking.com/#copyright-policy
pragma solidity ^0.8.13;
import "./IPool.sol";

contract Receiver {
    IPool pool;

    constructor(address _poolAddress) {
        pool = IPool(_poolAddress);
    }

    // TODO: Implement Receiver logic (Receiving a loan and paying it back)

    // TODO: Complete this function
    function flashLoan(uint256 amount) external {
        pool.flashLoan(amount);
    }

    // TODO: Complete getETH() payable function
    function getETH() external payable {
        (bool success, ) = address(pool).call{value: address(this).balance}("");
        require(success, "Repayment Failed!!!");
    }
}
