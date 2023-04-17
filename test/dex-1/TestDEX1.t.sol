// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "src/dex-1/Chocolate.sol";
import {IUniswapV2Pair} from "src/interfaces/IUniswapV2.sol";

/**
@dev run "forge test --fork-url $ETH_RPC_URL --fork-block-number 15969633 --match-contract DEX1" 
*/
contract TestDEX1 is Test {
    Chocolate chocolate;
    IUniswapV2Pair pair;

    address constant WETH_ADDRESS = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    address constant RICH_SIGNER = address(0x8EB8a3b98659Cce290402893d0123abb75E3ab28);

    uint128 constant ETH_BALANCE = 300 ether;
    uint128 constant INITIAL_MINT = 1000000 ether;
    uint128 constant INITIAL_LIQUIDITY = 100000 ether;
    uint128 constant ETH_IN_LIQUIDITY = 100 ether;

    uint128 constant TEN_ETH = 10 ether;
    uint128 constant HUNDRED_CHOCOLATES = 100 ether;

    address deployer = makeAddr("deployer");
    address user = makeAddr("user");

    IERC20 weth = IERC20(WETH_ADDRESS);

    function setUp() public {
        vm.label(WETH_ADDRESS, "WETH");
        vm.label(RICH_SIGNER, "RICH_SIGNER");

        vm.deal(user, 100 ether);
        address richSigner = RICH_SIGNER;

        // Send ETH from rich signer to our deployer
        vm.prank(richSigner);
        (bool success, ) = deployer.call{value: ETH_BALANCE}("");
        require(success, "Transfer Failed!!!");
    }

    function test_Attack() public {
        /************************Deployment************************/
        // TODO: Deploy your smart contract to `chocolate`, mint 1,000,000 tokens to deployer
        vm.prank(deployer);
        chocolate = new Chocolate(INITIAL_MINT);
        // TODO: Print newly created pair address and store pair contract to `this.pair`
        address pairAddress = chocolate.uniswapV2Pair();
        //console.log(pairAddress);
        pair = IUniswapV2Pair(pairAddress);

        /************************Deployer add liquidity tests************************/
        // TODO: Add liquidity of 100,000 tokens and 100 ETH (1 token = 0.001 ETH)
        vm.startPrank(deployer);
        chocolate.approve(address(chocolate), INITIAL_LIQUIDITY);
        chocolate.addChocolateLiquidity{value: ETH_IN_LIQUIDITY}(INITIAL_LIQUIDITY);
        vm.stopPrank();
        // TODO: Print the amount of LP tokens that the deployer owns
        uint256 lpBalance = pair.balanceOf(deployer);
        console.log(lpBalance);

        /************************User swap tests************************/
        uint256 userChocolateBalance = chocolate.balanceOf(user);
        uint256 userWETHBalance = weth.balanceOf(user);

        // TODO: From user: Swap 10 ETH to Chocolate
        vm.prank(user);
        chocolate.swapChocolates{value: TEN_ETH}(address(weth), TEN_ETH);
        // TODO: Make sure user received the chocolates (greater amount than before)
        assertEq(chocolate.balanceOf(user) > userChocolateBalance, true);

        // TODO: From user: Swap 100 Chocolates to ETH
        vm.startPrank(user);
        chocolate.approve(address(chocolate), HUNDRED_CHOCOLATES);
        chocolate.swapChocolates(address(chocolate), HUNDRED_CHOCOLATES);
        vm.stopPrank();

        // TODO: Make sure user received the WETH (greater amount than before)
        assertEq(weth.balanceOf(user) > userWETHBalance, true);

        /************************Deployer remove liquidity tests************************/
        uint256 deployerChocolateBalance = chocolate.balanceOf(deployer);
        uint256 deployerWETHBalance = weth.balanceOf(deployer);

        // TODO: Remove 50% of deployer's liquidity
        vm.startPrank(deployer);
        pair.approve(address(chocolate), lpBalance / 2);
        chocolate.removeChocolateLiquidity(lpBalance / 2);
        vm.stopPrank();

        // TODO: Make sure deployer owns 50% of the LP tokens (leftovers)
        assertEq(pair.balanceOf(deployer), lpBalance / 2);

        // TODO: Make sure deployer got chocolate and weth back (greater amount than before)
        assertEq(weth.balanceOf(deployer) > deployerWETHBalance, true);
    }
}
