// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {V1Exchange} from "../src/V1Exchange.sol";
import {V1Version} from "../src/V1Version.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract V1ExchangeTest is Test {
    V1Exchange public exchange;
    V1Version public token;
    uint256 private constant AMOUNT_SENT = 1_000 * 10 ** 18; // Initial token liquidity
    uint256 private constant LIQUIDITY_AMOUNT = 500 * 10 ** 18; // User adds liquidity
    address public user = address(0xA240CC375B0663A779d91A007AEa99CfA2e4f4A5);

    function setUp() public {
        token = new V1Version("Sample Token", "STK", 1_000_000 * 10 ** 18);
        exchange = new V1Exchange(address(token));
        token.transfer(address(exchange), AMOUNT_SENT);
        token.transfer(user, AMOUNT_SENT);
        vm.deal(user, 10 ether);
        vm.deal(address(exchange), 1 ether);
    }

    function testAddLiquidity() public {
        vm.startPrank(user);
        token.approve(address(exchange), LIQUIDITY_AMOUNT);
        exchange.addLiquidity{value: 0.5 ether}(LIQUIDITY_AMOUNT);
        vm.stopPrank();

        uint256 totalTokens = LIQUIDITY_AMOUNT + AMOUNT_SENT;
        uint256 totalEther = 1.5 ether;

        assertEq(exchange.getReserve(), totalTokens);
        assertEq(token.balanceOf(address(exchange)), totalTokens);
        assertEq(address(exchange).balance, totalEther);
    }

    function testGetEthAmount() public view {
        uint256 tokenSold = 100 * 10 ** 18;
        uint256 ethAmount = exchange.getEthAmount(tokenSold);
        uint256 expectedEthAmount = (tokenSold * address(exchange).balance) /
            (tokenSold + AMOUNT_SENT);

        assertEq(ethAmount, expectedEthAmount);
    }

    function testGetTokenAmount() public view {
        uint256 ethSold = 0.1 ether;
        uint256 tokenAmount = exchange.getTokenAmount(ethSold);
        uint256 expectedTokenAmount = (ethSold * AMOUNT_SENT) /
            (ethSold + address(exchange).balance);

        assertEq(tokenAmount, expectedTokenAmount);
    }

    function testTokenToEthSwap() public {
        uint256 tokenSold = 100 * 10 ** 18;
        uint256 expectedEthAmount = exchange.getEthAmount(tokenSold);

        vm.startPrank(user);
        token.approve(address(exchange), tokenSold);
        exchange.tokenToEthSwap(tokenSold, expectedEthAmount);
        vm.stopPrank();

        assertEq(token.balanceOf(user), AMOUNT_SENT - tokenSold);
        assertEq(address(exchange).balance, 1 ether - expectedEthAmount);
    }

    function testEthToTokenSwap() public {
        uint256 ethSold = 0.1 ether;
        uint256 expectedTokenAmount = exchange.getTokenAmount(ethSold);

        vm.startPrank(user);
        exchange.ethToTokenSwap{value: ethSold}(expectedTokenAmount);
        vm.stopPrank();

        assertEq(token.balanceOf(user), AMOUNT_SENT + expectedTokenAmount);
        assertEq(address(exchange).balance, 1 ether + ethSold);
    }
}
