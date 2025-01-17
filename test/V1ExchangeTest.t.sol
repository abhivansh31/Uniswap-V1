// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {V1Exchange} from "../src/V1Exchange.sol";
import {V1Version} from "../src/V1Version.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract V1ExchangeTest is Test {
    V1Exchange public exchange;
    V1Version public token;
    address public user = address(0xA240CC375B0663A779d91A007AEa99CfA2e4f4A5);

    function setUp() public {
        token = new V1Version("Sample Token", "STK", 1_000_000 * 10 ** 18);
        exchange = new V1Exchange(address(token));
        token.transfer(user, 1_000 * 10 ** 18);
    }

    function testAddLiquidity() public {
        uint256 liquidityAmount = 500 * 10 ** 18;
        vm.startPrank(user);
        token.approve(address(exchange), liquidityAmount);
        exchange.addLiquidity(liquidityAmount);
        vm.stopPrank();
        assertEq(exchange.getReserve(), liquidityAmount);
        assertEq(token.balanceOf(address(exchange)), liquidityAmount);
    }
}
