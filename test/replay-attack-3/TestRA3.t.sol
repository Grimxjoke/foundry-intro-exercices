// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {RedHawksVIP} from "src/replay-attack-3/RedHawksVIP.sol";
import {AttackRedHawksVIP} from "src/replay-attack-3/AttackRedHawksVIP.sol";

/**
@dev run "forge test --match-contract RA3 -vvvvv" 

@notice 🔥 The challenge is to solve this exercise by creating multiple samrt contracts instead of multiple EOAs and implement the solution in Foundry. 

*/
contract TestRA3 is Test {
    RedHawksVIP redHawks;
    AttackRedHawksVIP attackRedHawks;

    address deployer;
    address user;
    address attacker;

    address vouchersSigner;
    uint256 signerKey;

    function setUp() public {
        deployer = makeAddr("deployer");
        (vouchersSigner, signerKey) = makeAddrAndKey("vouchersSigner");
        user = makeAddr("user2");
        attacker = makeAddr("attacker");

        // Deploy the contract
        vm.prank(deployer);
        redHawks = new RedHawksVIP(vouchersSigner);

        // Create 2 NFTs voucher
        // This is how the signature you found on Ethereum mempool was created
        // Invalid signature (signed by another account)
        // Invalid signer doesn't work
        // Invalid data doesn't work
        // Can use valid voucher
        // 2 NFT minted
        // Can't use voucher twice
    }

    function testExploit() public {
        /** CODE YOUR SOLUTION HERE */
        /** SUCCESS CONDITIONS */
        // Attacker got all 178 VIP Membership Tickets
    }
}
