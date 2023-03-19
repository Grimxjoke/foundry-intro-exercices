// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/randomness-vulnerabilities-1/Game.sol";
import "../../src/randomness-vulnerabilities-1/Attack.sol";

/**
@dev run "forge test --match-contract RV1" 
*/
contract TestRV1 is Test {
    uint128 public constant GAME_POT = 10 ether;

    Game game;
    Attack attack;

    address deployer;
    address attacker;

    function setUp() public {
        deployer = address(1);
        attacker = address(2);

        vm.prank(deployer);
        game = new Game();
        vm.deal(address(game), GAME_POT);

        vm.prank(attacker);
        attack = new Attack(address(game));
        uint256 inGame = address(game).balance;
        assertEq(inGame, GAME_POT);
    }

    function test_Attack() public {
        attack.attack();

        assertEq(address(game).balance, 0);
        assertEq(address(attacker).balance, GAME_POT);
    }
}
