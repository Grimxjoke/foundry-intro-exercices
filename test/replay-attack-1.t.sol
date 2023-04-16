// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

import {MultiSignatureWallet} from "src/replay-attack-1/MultiSignatureWallet.sol";


contract ReplayAttack1Test is Test {
    //'Replay Attack Exercise 1'
    MultiSignatureWallet multiSigWallet;

    address deployer;
    uint256 deployerKey;

    address signer2;
    uint256 signer2Key;

    address attacker = makeAddr("attacker");
    
    uint256 constant ETH_IN_MULTISIG = 100 ether;
    uint256 constant ATTACKER_WITHDRAW = 1 ether;
    

    function setUp() public {
        /** SETUP EXERCISE - DON'T CHANGE ANYTHING HERE */
        (deployer, deployerKey) = makeAddrAndKey("deployer");
        (signer2, signer2Key) = makeAddrAndKey("signer2");

        // Deploy multisig
        address[2] memory signatories;
        signatories[0] = deployer;
        signatories[1] = signer2;
        multiSigWallet = new MultiSignatureWallet(signatories);

        // Fund multisig with ETH
        vm.deal(address(multiSigWallet), ETH_IN_MULTISIG);

        // Prepare withdraw Message
        bytes32 message = keccak256(
            abi.encodePacked(
                "\x19Ethereum Signed Message:\n52",
                attacker,
                ATTACKER_WITHDRAW
            )
        );

        // Sign message
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(deployerKey, message);
        // usually we would encodePacked here, but we don't need to
        // bytes memory deployerSignature = abi.encodePacked(r, s, v);
        MultiSignatureWallet.Signature memory deployerSignature = MultiSignatureWallet.Signature(v, r, s);
        console.log("Signature 1: ");
        console.log("v: ", v);
        console.log("r: ");
        console.logBytes32(r);
        console.log("s: ");
        console.logBytes32(s);

        (v, r, s) = vm.sign(signer2Key, message);
        // usually we would encodePacked here, but we don't need to
        // bytes memory signer2Signature = abi.encodePacked(r, s, v);
        MultiSignatureWallet.Signature memory signer2Signature = MultiSignatureWallet.Signature(v, r, s);
        console.log("Signature 1: ");
        console.log("v: ", v);
        console.log("r: ");
        console.logBytes32(r);
        console.log("s: ");
        console.logBytes32(s);

        
        // Call transfer with signatures

        MultiSignatureWallet.Signature[2] memory signs = [deployerSignature, signer2Signature];
        //[deployerSignature, signer2Signature];

        multiSigWallet.transfer(attacker, ATTACKER_WITHDRAW, signs);
    }

    function testExploit() public {
        assertEq(attacker.balance, ATTACKER_WITHDRAW, "attacker should have 1 ether by now");

        /// @dev importan data about signatures:
        /*
        Signature 1: 
            v:  27
            r: 0x1ddabf42460a80d2780a214aeec06787c1feb8046f4a88662db254e1ea1c15db
            s: 0x1ddb0931fa6572af9ea5bab4c7afd0779a095beb68a9ca160c8b23647d63f7f9
        Signature 1: 
            v:  27
            r: 0xada7024b0ac3b997b1d05eedf4ba6020f1fdc92eaae47c2e9c6ec354ec86b075
            s: 0x541172db522d0cc2ef6c651c8ef67b9f8fb858b394e239d8d1507e58356f787c
        */

        vm.startPrank(attacker);
        /** CODE YOUR SOLUTION HERE */

        

        /** END SOLUTION */

        /** WINNING CONDITION */
        // Attacker is supposed to own the stolen ETH ( +99 ETH , -0.1 ETH for gas)
        assertGt(attacker.balance, 99 ether, "Mission fail, not enough ETH stolen");
    }
}