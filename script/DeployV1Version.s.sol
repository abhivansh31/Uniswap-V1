// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {V1Version} from "../src/V1Version.sol";

contract DeployToken is Script {
    function run() external returns (V1Version) {
        vm.startBroadcast();
        V1Version token = new V1Version(
            "Sample Token",
            "STK",
            1_000_000 * 10 ** 18
        );
        vm.stopBroadcast();
        return token;
    }
}
