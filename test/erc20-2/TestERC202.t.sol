// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../../src/erc20-2/TokensDepository.sol";
import "../../src/erc20-2/rToken.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
@dev run "forge test --fork-url $ETH_RPC_URL --fork-block-number 15969633 --match-contract ERC202" 
*/

contract TestERC202 is Test {
    TokensDepository public tokensDepository;

    address deployer;
    address aaveHolder;
    address uniHolder;
    address wethHolder;

    uint256 initAaveBalance;
    uint256 initUniBalance;
    uint256 initWethBalance;

    address AAVE_ADDRESS = address(0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9);
    address UNI_ADDRESS = address(0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984);
    address WETH_ADDRESS = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    function setUp() public {
        deployer = address(1);

        // Load holders (accounts which hold tokens on Mainnet)
        aaveHolder = address(0x2eFB50e952580f4ff32D8d2122853432bbF2E204);
        uniHolder = address(0x193cEd5710223558cd37100165fAe3Fa4dfCDC14);
        wethHolder = address(0x741AA7CFB2c7bF2A1E7D4dA2e3Df6a56cA4131F3);

        tokensDepository = new TokensDepository(AAVE_ADDRESS, UNI_ADDRESS, WETH_ADDRESS);

        // Send some ETH to tokens holders
        vm.deal(aaveHolder, 1 ether);
        vm.deal(uniHolder, 1 ether);
        vm.deal(wethHolder, 1 ether);

        initAaveBalance = IERC20(AAVE_ADDRESS).balanceOf(aaveHolder);
        initUniBalance = IERC20(UNI_ADDRESS).balanceOf(uniHolder);
        initWethBalance = IERC20(WETH_ADDRESS).balanceOf(wethHolder);
    }

    function test_Depository() public {
        console.log("Testing Deposits...");
        // TODO: Deposit Tokens

        // 15 AAVE from AAVE
        vm.startPrank(aaveHolder);
        IERC20(AAVE_ADDRESS).approve(address(tokensDepository), 15 ether);
        tokensDepository.deposit(AAVE_ADDRESS, 15 ether);
        vm.stopPrank();

        // 5231 UNI from UNI Holder
        vm.startPrank(uniHolder);
        IERC20(UNI_ADDRESS).approve(address(tokensDepository), 5213 ether);
        tokensDepository.deposit(UNI_ADDRESS, 5213 ether);
        vm.stopPrank();

        // 33 WETH from WETH Holder
        vm.startPrank(wethHolder);
        IERC20(WETH_ADDRESS).approve(address(tokensDepository), 33 ether);
        tokensDepository.deposit(WETH_ADDRESS, 33 ether);
        vm.stopPrank();

        // TODO: Check that the tokens were sucessfuly transfered to the depository
        assertEq(IERC20(AAVE_ADDRESS).balanceOf(address(tokensDepository)), 15 ether);
        assertEq(IERC20(UNI_ADDRESS).balanceOf(address(tokensDepository)), 5213 ether);
        assertEq(IERC20(WETH_ADDRESS).balanceOf(address(tokensDepository)), 33 ether);

        // TODO: Check that the right amount of receipt tokens were minted
        assertEq(tokensDepository.rTokens(AAVE_ADDRESS).balanceOf(aaveHolder), 15 ether);
        assertEq(tokensDepository.rTokens(UNI_ADDRESS).balanceOf(uniHolder), 5213 ether);
        assertEq(tokensDepository.rTokens(WETH_ADDRESS).balanceOf(wethHolder), 33 ether);

        console.log("Testing Withdraws...");

        // TODO: Withdraw ALL the Tokens
        vm.prank(aaveHolder);
        tokensDepository.withdraw(AAVE_ADDRESS, 15 ether);
        vm.prank(uniHolder);
        tokensDepository.withdraw(UNI_ADDRESS, 5213 ether);
        vm.prank(wethHolder);
        tokensDepository.withdraw(WETH_ADDRESS, 33 ether);

        // TODO: Check that the right amount of tokens were withdrawn (depositors got back the assets)
        assertEq(IERC20(AAVE_ADDRESS).balanceOf(aaveHolder), initAaveBalance);
        assertEq(IERC20(UNI_ADDRESS).balanceOf(uniHolder), initUniBalance);
        assertEq(IERC20(WETH_ADDRESS).balanceOf(wethHolder), initWethBalance);

        // TODO: Check that the right amount of receipt tokens were burned
        assertEq(tokensDepository.rTokens(AAVE_ADDRESS).balanceOf(aaveHolder), 0);
        assertEq(tokensDepository.rTokens(UNI_ADDRESS).balanceOf(uniHolder), 0);
        assertEq(tokensDepository.rTokens(WETH_ADDRESS).balanceOf(wethHolder), 0);
    }
}
