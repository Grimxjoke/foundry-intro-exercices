// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "src/flash-loan-attacks-1/AttackPool.sol";
import "src/flash-loan-attacks-1/Pool.sol";
import "src/flash-loan-attacks-1/Token.sol";

/**
@dev run "forge test --match-contract FLA1 -vvvvv" 
*/
contract TestFLA1 is Test {
    AttackPool attackPool;
    Pool pool;
    Token token;

    uint constant POOL_TOKENS = 100000000 ether;
    address deployer = makeAddr("deployer");
    address attacker = makeAddr("attacker");

    function setUp() public {
        /** SETUP EXERCISE - DON'T CHANGE ANYTHING HERE */
        vm.startPrank(deployer);

        // Deploy token & pool
        token = new Token();
        pool = new Pool(address(token));

        // Transfer tokens to pool
        token.transfer(address(pool), POOL_TOKENS);

        vm.stopPrank();

        // Pool should have 100M, attacker should have 0 tokens
        assertEq(token.balanceOf(address(pool)), POOL_TOKENS);
        assertEq(token.balanceOf(address(attacker)), 0);
    }

    function test_Attack() public {
        /** CODE YOUR SOLUTION HERE */
        vm.startPrank(attacker);
        attackPool = new AttackPool(address(pool), address(token));
        attackPool.attack();
        vm.stopPrank();

        /** SUCCESS CONDITIONS */
        // Attacker successfully stole all tokens form the pool
        assertEq(token.balanceOf(address(pool)), 0);
        assertEq(token.balanceOf(address(attacker)), POOL_TOKENS);
    }
}
