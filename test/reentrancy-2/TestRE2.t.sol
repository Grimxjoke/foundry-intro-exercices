// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/reentrancy-2/ApesAirdrop.sol";
import "../../src/reentrancy-2/AttackAirdrop.sol";

/**
@dev run "forge test --match-contract RV2" 
*/
contract TestRE2 is Test {
    uint256 init_attacker_bal;
    uint256 init_bank_bal;

    ApesAirdrop airdrop;
    AttackAirdrop attackAirdrop;

    address deployer;
    address user1;
    address user2;
    address user3;
    address user4;
    address attacker;

    function setUp() public {
        deployer = address(1);
        user1 = address(2);
        user2 = address(3);
        user3 = address(4);
        user4 = address(5);
        attacker = address(6);

        vm.deal(user1, 100 ether);
        vm.deal(user2, 100 ether);
        vm.deal(user3, 100 ether);
        vm.deal(user4, 100 ether);
        vm.deal(attacker, 100 ether);

        vm.prank(deployer);
        airdrop = new ApesAirdrop();

        address[] memory users = new address[](5);
        users[0] = user1;
        users[1] = user2;
        users[2] = user3;
        users[3] = user4;
        users[4] = attacker;

        vm.prank(deployer);
        airdrop.addToWhitelist(users);

        vm.prank(attacker);
        attackAirdrop = new AttackAirdrop(address(airdrop));
    }

    function test_Attack() public {
        vm.prank(attacker);
        airdrop.grantMyWhitelist(address(attackAirdrop));

        attackAirdrop.attack();

        assertEq(airdrop.balanceOf(address(attacker)), 50);
    }
}
