// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../../src/erc721-1/MyNFT.sol";

/**
@dev run "forge test --match-contract ERC201" 
*/
contract TestERC7211 is Test {
    MyNFT public myNft;

    address deployer;
    address user1;
    address user2;

    function setUp() public {
        deployer = address(1);
        user1 = address(2);
        user2 = address(3);

        vm.deal(deployer, 1 ether);
        vm.deal(user1, 1 ether);

        myNft = new MyNFT();
    }

    function test() public {
        // TODO: Deployer mints

        // Deployer should own token ids 1-5
        for (uint i = 1; i <= 5; i++) {
            vm.prank(deployer);
            myNft.mint{value: 0.1 ether}();
        }
        assertEq(myNft.balanceOf(deployer), 5);

        // User1 should own token ids 6-8
        for (uint i = 1; i <= 3; i++) {
            vm.prank(user1);
            myNft.mint{value: 0.1 ether}();
        }
        assertEq(myNft.balanceOf(user1), 3);

        // TODO: Transfering tokenId 6 from user1 to user2
        vm.prank(user1);
        myNft.transferFrom(user1, user2, 6);
        // TODO: Checking that user2 owns tokenId 6
        assertEq(myNft.ownerOf(6), user2);
        // TODO: Deployer approves User1 to spend tokenId 3
        vm.prank(deployer);
        myNft.approve(user1, 3);
        // TODO: Test that User1 has approval to spend TokenId3
        assertEq(myNft.getApproved(3), user1);
        // TODO: Use approval and transfer tokenId 3 from deployer to User1
        vm.prank(user1);
        myNft.transferFrom(deployer, user1, 3);
        // TODO: Checking that user1 owns tokenId 3
        assertEq(myNft.ownerOf(3), user1);
        // TODO: Checking balances after transfer
        // Deployer: 5 minted, 1 sent, 0 received
        assertEq(myNft.balanceOf(deployer), 4);
        // User1: 3 minted, 1 sent, 1 received
        assertEq(myNft.balanceOf(user1), 3);
        // User2: 0 minted, 0 sent, 1 received
        assertEq(myNft.balanceOf(user2), 1);
    }
}
