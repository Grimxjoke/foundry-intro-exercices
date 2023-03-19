// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../../src/erc721-2/OpenOcean.sol";
import "../../src/utils/DummyERC721.sol";

/**
@dev run "forge test --match-contract ERC201" 
*/
contract TestERC7212 is Test {
    uint128 public constant CUTE_NFT_PRICE = 5 ether;
    uint128 public constant BOOBLES_NFT_PRICE = 7 ether;

    OpenOcean public marketPlace;
    DummyERC721 public cuteNFT;
    DummyERC721 public booblesNFT;

    address deployer;
    address user1;
    address user2;
    address user3;

    uint256 init_user1_bal;
    uint256 init_user2_bal;
    uint256 init_user3_bal;

    function setUp() public {
        deployer = address(1);
        user1 = address(2);
        user2 = address(3);
        user3 = address(4);

        vm.deal(deployer, 100 ether);
        vm.deal(user1, 100 ether);
        vm.deal(user2, 100 ether);
        vm.deal(user3, 100 ether);

        init_user1_bal = user1.balance;
        init_user2_bal = user2.balance;
        init_user3_bal = user3.balance;

        vm.prank(deployer);
        marketPlace = new OpenOcean();

        vm.startPrank(user1);
        cuteNFT = new DummyERC721("Crypto Cuties", "CUTE", 1000);
        cuteNFT.mintBulk(30);
        vm.stopPrank();

        vm.startPrank(user3);
        booblesNFT = new DummyERC721("Rare Boobles", "BOO", 10000);
        booblesNFT.mintBulk(120);
        vm.stopPrank();
    }

    function test_NFT() public {
        console.log("Running Listing Tests...");

        // TODO: User1 lists Cute NFT tokens 1-10 for 5 ETH each
        for (uint i = 1; i <= 10; i++) {
            vm.startPrank(user1);
            cuteNFT.approve(address(marketPlace), i);
            marketPlace.listItem(address(cuteNFT), i, CUTE_NFT_PRICE);
            vm.stopPrank();
        }
        assertEq(marketPlace.itemsCounter(), 10);
        // TODO: Check that Marketplace owns 10 Cute NFTs
        for (uint i = 1; i <= 10; i++) {
            assertEq(cuteNFT.ownerOf(i), address(marketPlace));
        }
        // TODO: Checks that the marketplace mapping is correct (All data is correct), check the 10th item.
        (
            uint256 itemId,
            address collectionContract,
            uint256 tokenId,
            uint256 price,
            address payable seller,
            bool isSold
        ) = marketPlace.listedItems(10);

        assertEq(itemId, 10);
        assertEq(collectionContract, address(cuteNFT));
        assertEq(tokenId, 10);
        assertEq(price, CUTE_NFT_PRICE);
        assertEq(seller, user1);
        assertEq(isSold, false);

        // TODO: User3 lists Boobles NFT tokens 1-5 for 7 ETH each
        for (uint i = 1; i <= 5; i++) {
            vm.startPrank(user3);
            booblesNFT.approve(address(marketPlace), i);
            marketPlace.listItem(address(booblesNFT), i, BOOBLES_NFT_PRICE);
            vm.stopPrank();
        }
        assertEq(marketPlace.itemsCounter(), 15);
        // TODO: Check that Marketplace owns 5 Booble NFTs
        for (uint i = 1; i <= 5; i++) {
            assertEq(booblesNFT.ownerOf(i), address(marketPlace));
        }
        // TODO: Checks that the marketplace mapping is correct (All data is correct), check the 15th item.
        (itemId, collectionContract, tokenId, price, seller, isSold) = marketPlace.listedItems(15);

        assertEq(itemId, 15);
        assertEq(collectionContract, address(booblesNFT));
        assertEq(tokenId, 5);
        assertEq(price, BOOBLES_NFT_PRICE);
        assertEq(seller, user3);
        assertEq(isSold, false);
        console.log("Listing Tests Successful!!!");

        // All Purchases From User2 //
        console.log("Running Purchase Tests...");
        vm.startPrank(user2);
        // TODO: Try to purchase itemId 100, should revert
        vm.expectRevert();
        marketPlace.purchase(100);
        // TODO: Try to purchase itemId 3, without ETH, should revert
        vm.expectRevert();
        marketPlace.purchase(3);
        // TODO: Try to purchase itemId 3, with ETH, should work
        marketPlace.purchase{value: CUTE_NFT_PRICE}(3);
        // TODO: Can't purchase sold item
        vm.expectRevert();
        marketPlace.purchase{value: CUTE_NFT_PRICE}(3);
        // TODO: User2 owns itemId 3 -> Cuties tokenId 3
        assertEq(cuteNFT.ownerOf(3), user2);
        // TODO: User1 got the right amount of ETH for the sale
        assertEq(user1.balance > (init_user1_bal + CUTE_NFT_PRICE - 0.2 ether), true);
        // TODO: Purchase itemId 11
        marketPlace.purchase{value: BOOBLES_NFT_PRICE}(11);
        // TODO: User2 owns itemId 11 -> Boobles tokenId 1
        assertEq(booblesNFT.ownerOf(1), user2);
        // TODO: User3 got the right amount of ETH for the sale
        assertEq(user3.balance > (init_user3_bal + BOOBLES_NFT_PRICE - 0.2 ether), true);

        vm.stopPrank();
        console.log("Purchase Tests Successful!!!");
    }
}
