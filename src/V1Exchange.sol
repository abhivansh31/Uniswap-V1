//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract V1Exchange {
    address public tokenAddress;

    constructor(address _token) { 
        require(_token != address(0), "Invalid Token Address");
        tokenAddress = _token;
    }

    function addLiquidity(uint256 _tokenAmmount) public payable {
        IERC20 token = IERC20(tokenAddress);
        token.transferFrom(msg.sender, address(this), _tokenAmmount);
    }

    function getReserve() public view returns (uint256) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }
}
