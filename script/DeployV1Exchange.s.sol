// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script, console} from "forge-std/Script.sol";
import {V1Exchange} from "../src/V1Exchange.sol";
import {V1Version} from "../src/V1Version.sol";

contract DeployV1Exchange is Script {
    function run() external returns (V1Exchange) {
        V1Version version;
        V1Exchange exchange;
        vm.startBroadcast();
        version = new V1Version("Abhi", "ABH", 100000 * 10 ** 18);
        exchange = new V1Exchange(address(version));
        vm.stopBroadcast();
        return exchange;
    }
}
