// SCH Course Copyright Policy (C): DO-NOT-SHARE-WITH-ANYONE
// https://smartcontractshacking.com/#copyright-policy
pragma solidity ^0.8.13;
import "./IPool.sol";

contract GreedyReceiver {
    IPool pool;

    constructor(address _poolAddress) {
        pool = IPool(_poolAddress);
    }

    // TODO: Implement Greedy Receiver Logic (Not paying back the loan)

    // TODO: Complete this function
    function flashLoan(uint256 amount) external {
        pool.flashLoan(amount);
    }

    // TODO: Complete getETH() payable function
    function getETH() external payable {}
}
