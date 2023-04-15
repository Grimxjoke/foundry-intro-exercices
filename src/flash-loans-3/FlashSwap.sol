// SCH Course Copyright Policy (C): DO-NOT-SHARE-WITH-ANYONE
// https://smartcontractshacking.com/#copyright-policy
pragma solidity ^0.8.13;

import "../interfaces/IPair.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "forge-std/console.sol";

/**
 * @title FlashSwap
 * @author JohnnyTime (https://smartcontractshacking.com)
 */
contract FlashSwap {
    IPair pair;
    address token;
    uint256 fee;

    constructor(address _pair, uint256 _fee) {
        pair = IPair(_pair);
        fee = _fee;
    }

    // TODO: Implement this function
    function executeFlashSwap(address _token, uint256 _amount) external {
        token = _token;
        console.log("Before Flash Swap: %s", IERC20(token).balanceOf(address(this)));
        if (token == pair.token0()) {
            pair.swap(_amount, 0, address(this), "0x0");
        } else {
            pair.swap(0, _amount, address(this), "0x0");
        }
    }

    // TODO: Implement this function
    function uniswapV2Call(address /*sender*/, uint amount0, uint amount1, bytes calldata /*data*/) external {
        assert(msg.sender == address(pair));

        address token0 = pair.token0();
        address token1 = pair.token1();

        console.log("During Flash Swap: %s", IERC20(token).balanceOf(address(this)));
        console.log("Flash Swap Fee: %s", fee);

        if (token == token0) {
            IERC20(token0).transfer(msg.sender, amount0 + fee);
        } else {
            IERC20(token1).transfer(msg.sender, amount1 + fee);
        }
    }
}
