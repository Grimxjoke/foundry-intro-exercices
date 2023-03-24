// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/reentrancy-4/AttackCryptoEmpire.sol";
import "../../src/reentrancy-4/CryptoEmpireGame.sol";
import "../../src/reentrancy-4/CryptoEmpireToken.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
@dev run "forge test --fork-url $ETH_RPC_URL --fork-block-number 15969633 --match-contract RE4 -vvv" 
*/
contract TestRE4 is Test {
    CryptoEmpireToken token;
    CryptoEmpireGame game;
    AttackCryptoEmpire attackgame;

    address deployer;
    address user1;
    address user2;
    address attacker;

    CryptoEmpireToken.NftId public nftId;

    function getEnum() public {
        return nftId;
    }

    function setUp() public {
        deployer = address(1);
        user1 = address(2);
        user2 = address(3);
        attacker = address(4);

        vm.startPrank(deployer);
        token = new CryptoEmpireToken();
        game = new CryptoEmpireGame(address(token));

        // Giving 1 NFT to each user
        token.mint(user1, 1, nftId.HELMET);
        token.mint(user2, 1, 0);
        token.mint(attacker, 1, 2);

        // The CryptoEmpire game gained many users already and has some NFTs either staked or listed in it
        token.mint(address(game), 20, 0);

        vm.stopPrank();
    }

    function test_Attack() public {
        vm.startPrank(attacker);
        attackgame = new AttackCryptoEmpire(address(game), address(token));

        vm.stopPrank();
    }
}
