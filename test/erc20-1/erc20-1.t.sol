// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/erc20-1/MyToken.sol";

contract TestERC20_1 is Test {
    MyToken public myToken;
    address deployer;
    address user1;
    address user2;
    address user3;

    uint256 DEPLOYER_MINT = 100000 ether;
    uint256 USERS_MINT = 5000 ether;
    uint256 FIRST_TRANSFER = 100 ether;
    uint256 SECOND_TRANSFER = 1000 ether;

    function setUp() public {
        myToken = new MyToken();
        deployer = address(1);
        user1 = address(2);
        user2 = address(3);
        user3 = address(4);

        myToken.mint(deployer, DEPLOYER_MINT);
        myToken.mint(user1, USERS_MINT);
        myToken.mint(user2, USERS_MINT);
        myToken.mint(user3, USERS_MINT);
        assertEq(myToken.balanceOf(deployer), DEPLOYER_MINT);
        assertEq(myToken.balanceOf(user2), USERS_MINT);
    }

    function testTransfers() public {
        vm.prank(user2);
        myToken.transfer(user3, FIRST_TRANSFER);

        vm.prank(user3);
        myToken.approve(user1, SECOND_TRANSFER);
        assertEq(myToken.allowance(user3, user1), SECOND_TRANSFER);

        vm.prank(user1);
        myToken.transferFrom(user3, user1, SECOND_TRANSFER);

        assertEq(myToken.balanceOf(user1), USERS_MINT + SECOND_TRANSFER);
        assertEq(myToken.balanceOf(user2), USERS_MINT - FIRST_TRANSFER);
        assertEq(myToken.balanceOf(user3), USERS_MINT - SECOND_TRANSFER + FIRST_TRANSFER);
    }
}
