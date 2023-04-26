// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "src/flash-loan-attacks-2/AttackAdvancedVault.sol";
import "src/flash-loan-attacks-2/AdvancedVault.sol";

/**
@dev run "forge test --match-contract FLA2 -vvvvv" 
*/
contract TestFLA2 is Test {
    AttackAdvancedVault attackVault;
    AdvancedVault vault;

    uint256 attackerInitialBalance;

    uint constant ETH_IN_VAULT = 1000 ether;
    address deployer = makeAddr("deployer");
    address attacker = makeAddr("attacker");

    function setUp() public {
        /** SETUP EXERCISE - DON'T CHANGE ANYTHING HERE */
        vm.startPrank(deployer);

        // Deploy vault
        vault = new AdvancedVault();

        //Deposit ETH_IN_VAULT
        vm.deal(deployer, 10000 ether);
        vault.depositETH{value: ETH_IN_VAULT}();
        vm.stopPrank();

        // Pool should have 100M, attacker should have 0 tokens
        attackerInitialBalance = address(attacker).balance;
        assertEq((address(vault)).balance, ETH_IN_VAULT);
    }

    function test_Attack() public {
        /** CODE YOUR SOLUTION HERE */
        vm.startPrank(attacker);
        attackVault = new AttackAdvancedVault(address(vault));
        attackVault.attack();
        vm.stopPrank();

        /** SUCCESS CONDITIONS */
        assertEq((address(vault)).balance, 0);
        assertEq((address(attacker)).balance, ETH_IN_VAULT);
    }
}
