//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {V1Exchange} from "./V1Exchange.sol";
import {V1Version} from "./V1Version.sol";

contract V1Factory {
    mapping(address => address) public tokenToExchange;

    function createExchange(address _tokenAddress) public returns (address) {
        require(_tokenAddress != address(0), "Invalid Token Address");
        require(
            tokenToExchange[_tokenAddress] == address(0),
            "Exchange already exists"
        );
        V1Exchange exchange = new V1Exchange(_tokenAddress);
        tokenToExchange[_tokenAddress] = address(exchange);
        return address(exchange);
    }

    function getExchange(address _tokenAddress) public view returns (address) {
        return tokenToExchange[_tokenAddress];
    }
}
