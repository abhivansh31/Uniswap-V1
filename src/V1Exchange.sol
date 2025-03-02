//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface IFactory {
    function getExchange(address _tokenAddress) external returns (address);
}

interface IExchange {
    function ethToTokenSwap(uint256 _minTokens) external payable;
}

contract V1Exchange is ERC20 {
    address public tokenAddress;
    address public factoryAddress;

    receive() external payable {}

    constructor(address _token) ERC20("Zuniswap", "ZV1") {
        require(_token != address(0), "Invalid Token Address");
        tokenAddress = _token;
        factoryAddress = msg.sender;
    }

    function addLiquidity(uint256 _tokenAmount) public payable {
        if (getReserve() == 0) {
            IERC20 token = IERC20(tokenAddress);
            token.transferFrom(msg.sender, address(this), _tokenAmount);
            uint256 liquidityTokens = address(this).balance;
            _mint(msg.sender, liquidityTokens);
        } else {
            uint256 ethReserve = address(this).balance - msg.value;
            uint256 tokenReserve = getReserve();
            uint256 tokenAmount = (msg.value * tokenReserve) / ethReserve;
            require(_tokenAmount >= tokenAmount, "Invalid token amount");
            IERC20 token = IERC20(tokenAddress);
            token.transferFrom(msg.sender, address(this), tokenAmount);
            uint256 liquidityTokens = (tokenAmount * msg.value) / ethReserve;
            _mint(msg.sender, liquidityTokens);
        }
    }

    function getReserve() public view returns (uint256) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }

    function getAmount(
        uint256 inputAmount,
        uint256 inputReserve,
        uint256 outputReserve
    ) public pure returns (uint256) {
        require(inputReserve > 0 && outputReserve > 0, "Not enough reserves");
        uint256 inputAmountWithFee = inputAmount * 99;
        uint256 numerator = inputAmountWithFee * outputReserve;
        uint256 denominator = (inputReserve * 100) + inputAmountWithFee;

        return numerator / denominator;
    }

    function getEthAmount(uint256 _tokenSold) public view returns (uint256) {
        require(_tokenSold > 0, "Not enough tokens sold");
        uint256 tokenReserve = getReserve();
        return getAmount(_tokenSold, tokenReserve, address(this).balance);
    }

    function getTokenAmount(uint256 _ethSold) public view returns (uint256) {
        require(_ethSold > 0, "Not enough eth sold");
        uint256 tokenReserve = getReserve();
        return getAmount(_ethSold, address(this).balance, tokenReserve);
    }

    function ethToToken(uint256 _minTokens, address recipient) private {
        uint256 tokenReserve = getReserve();
        uint256 tokensBought = getAmount(
            msg.value,
            address(this).balance - msg.value,
            tokenReserve
        );

        require(tokensBought >= _minTokens, "insufficient output amount");

        IERC20(tokenAddress).transfer(recipient, tokensBought);
    }

    function ethToTokenSwap(uint256 _minTokens) public payable {
        ethToToken(_minTokens, msg.sender);
    }

    function tokenToEthSwap(uint256 tokenAmount, uint256 minimumEth) public {
        uint256 tokenReserve = getReserve();
        uint256 ethAmount = getAmount(
            tokenAmount,
            tokenReserve,
            address(this).balance
        );

        require(ethAmount >= minimumEth, "Not enough eth");
        IERC20(tokenAddress).transferFrom(
            msg.sender,
            address(this),
            tokenAmount
        );
        payable(msg.sender).transfer(ethAmount);
    }

    function removeLiquidity(
        uint256 _amount
    ) public returns (uint256, uint256) {
        require(_amount > 0, "Not Enough LP Tokens");
        uint256 ethAmount = (address(this).balance * _amount) / totalSupply();
        uint256 tokenAmount = (getReserve() * _amount) / totalSupply();

        _burn(msg.sender, _amount);
        payable(msg.sender).transfer(ethAmount);
        IERC20(tokenAddress).transfer(msg.sender, tokenAmount);

        return (ethAmount, tokenAmount);
    }

    function tokenToTokenSwap(
        uint256 _tokensSold,
        uint256 _minTokensBought,
        address _tokenAddress
    ) public {
        address exchangeAddress = IFactory(factoryAddress).getExchange(
            _tokenAddress
        );
        require(
            exchangeAddress != address(this) && exchangeAddress != address(0),
            "invalid exchange address"
        );

        uint256 tokenReserve = getReserve();
        uint256 ethBought = getAmount(
            _tokensSold,
            tokenReserve,
            address(this).balance
        );

        IERC20(tokenAddress).transferFrom(
            msg.sender,
            address(this),
            _tokensSold
        );
        IExchange(exchangeAddress).ethToTokenSwap{value: ethBought}(
            _minTokensBought
        );
    }
}
