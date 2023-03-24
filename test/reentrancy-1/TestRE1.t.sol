// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/reentrancy-1/EtherBank.sol";
import "../../src/reentrancy-1/AttackBank.sol";

/**
@dev run "forge test --match-contract RV2" 
*/
contract TestRE1 is Test {
    uint128 public constant USER1_DEPOSIT = 12 ether;
    uint128 public constant USER2_DEPOSIT = 6 ether;
    uint128 public constant USER3_DEPOSIT = 28 ether;
    uint128 public constant USER4_DEPOSIT = 63 ether;

    uint256 init_attacker_bal;
    uint256 init_bank_bal;

    EtherBank bank;
    AttackBank attackBank;

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
        bank = new EtherBank();

        vm.prank(attacker);
        attackBank = new AttackBank(address(bank));

        vm.prank(user1);
        bank.depositETH{value: USER1_DEPOSIT}();
        vm.prank(user2);
        bank.depositETH{value: USER2_DEPOSIT}();
        vm.prank(user3);
        bank.depositETH{value: USER3_DEPOSIT}();
        vm.prank(user4);
        bank.depositETH{value: USER4_DEPOSIT}();

        init_attacker_bal = address(attacker).balance;

        init_bank_bal = address(bank).balance;

        assertEq(init_bank_bal, USER1_DEPOSIT + USER2_DEPOSIT + USER3_DEPOSIT + USER4_DEPOSIT);
    }

    function test_Attack() public {
        attackBank.attack{value: 1 ether}();
        assertEq(address(bank).balance, 0);

        assertEq(address(attacker).balance, init_attacker_bal + init_bank_bal + 1 ether);
    }
}
