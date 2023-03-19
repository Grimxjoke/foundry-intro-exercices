// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/randomness-vulnerabilities-2/Game2.sol";
import "../../src/randomness-vulnerabilities-2/Attack.sol";

/**
@dev run "forge test --match-contract ERC201" 
*/
contract TestRV2 is Test {
    uint128 public constant GAME_POT = 20 ether;
    uint128 public constant GAME_FEE = 1 ether;
    uint256 init_attacker_bal;

    Game2 game;
    Attack attack;

    address deployer;
    address attacker;

    function setUp() public {
        deployer = address(1);
        attacker = address(2);
        vm.deal(attacker, 10 ether);

        vm.prank(deployer);
        game = new Game2();
        vm.deal(address(game), GAME_POT);

        vm.prank(attacker);
        attack = new Attack(address(game));

        uint256 inGame = address(game).balance;
        assertEq(inGame, GAME_POT);

        init_attacker_bal = address(attacker).balance;
    }

    function test_Attack() public {
        for (uint i = 0; i < 5; i++) {
            attack.attack{value: 1 ether}();
            vm.roll(block.number + 1);
        }

        assertEq(address(game).balance, 0);
        assertEq(address(attacker).balance >= init_attacker_bal + GAME_POT, true);
    }
}
