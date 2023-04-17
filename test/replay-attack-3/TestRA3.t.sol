// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {RedHawksVIP} from "src/replay-attack-3/RedHawksVIP.sol";
import {AttackRedHawksVIP} from "src/replay-attack-3/AttackRedHawksVIP.sol";

/**
@dev run "forge test --match-contract RA3 -vvvvv" 
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
    }

    function testExploit() public {}
}
