// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "src/flash-loans-1/Receiver.sol";
import "src/flash-loans-1/GreedyReceiver.sol";
import "src/flash-loans-1/Pool.sol";

/**
@dev run "forge test --match-contract FL1 -vvvvv" 
*/
contract TestFL1 is Test {
    uint128 constant POOL_BALANCE = 1000 ether;

    GreedyReceiver greedy;
    Receiver receiver;
    Pool pool;

    address user;
    address deployer;

    function setUp() public {
        deployer = address(123);
        user = address(456);

        vm.deal(deployer, POOL_BALANCE);
        // TODO: Deploy Pool.sol contract with 1,000 ETH
        vm.prank(deployer);
        pool = new Pool{value: POOL_BALANCE}();

        vm.startPrank(user);
        // TODO: Deploy Receiver.sol contract
        receiver = new Receiver(address(pool));
        // TODO: Deploy GreedyReceiver.sol contract
        greedy = new GreedyReceiver(address(pool));
        vm.stopPrank();
    }

    function test_Attack() public {
        // TODO: Successfuly execute a Flash Loan of all the balance using Receiver.sol contract
        receiver.flashLoan(address(pool).balance);
        // TODO: Fails to execute a flash loan with GreedyReceiver.sol contract
        vm.expectRevert("Flashloan not paid back!!!");
        greedy.flashLoan(address(pool).balance);
    }
}
