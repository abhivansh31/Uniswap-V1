// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script, console} from "forge-std/Script.sol";
import {V1Exchange} from "../src/V1Exchange.sol";

contract DeployExchange is Script {
    function run() external returns (V1Exchange) {
        address tokenAddress = 0xf05655805A6421c7d03D0dfD029C836F8d37d1A1;
        vm.startBroadcast();
        V1Exchange exchange = new V1Exchange(tokenAddress);
        vm.stopBroadcast();
        return exchange;
    }
}
