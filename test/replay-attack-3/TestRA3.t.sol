// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {RedHawksVIP} from "src/replay-attack-3/RedHawksVIP.sol";
import {AttackRedHawksVIP} from "src/replay-attack-3/AttackRedHawksVIP.sol";

/**
@dev run "forge test --match-contract RA3 -vvvvv" 

@notice This exercise has a different logic than original solution: The idea is to create multiple samrt contracts (~89 contracts).

@notice 🔥 The challenge is to use this approach and implement the solution in Foundry. Obviously, after you have implemented the orginal solution,

****************Hint****************
Here's the logic in javascript using AttackRedHawksVIP.sol
for (let i = 1; i <= 89; i++) {
        //Creating the smart contract
      this.attackredHawks = await AttackRedHawksFactory.deploy(
        this.redHawks.address
      );

    //Using the smart contract to attack RedHawksVIP
      j++;
      this.attackredHawks.attack(i, j, "RedHawksRulzzz133", validSignature);
      console.log(`Minted: ${i + j}, ${i + j + 1}`);
    }
****************Hint****************
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
