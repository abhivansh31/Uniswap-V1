# Smart Contracts for V1 Exchange and Token

This repository contains the smart contracts for the V1 Exchange and the associated token, implemented in Solidity. The contracts are designed for decentralized trading on the Ethereum blockchain.

## Overview

### V1Exchange Contract

The `V1Exchange` contract facilitates the exchange of tokens and ETH. It allows users to add liquidity, swap tokens, and remove liquidity. The contract implements the following key features:

- **Add Liquidity**: Users can add ETH and tokens to the exchange, minting liquidity tokens in return.
- **Token Swaps**: Users can swap ETH for tokens and vice versa.
- **Remove Liquidity**: Users can withdraw their share of the liquidity from the exchange.

### V1Version Contract

The `V1Version` contract is an ERC20 token that represents the tradable asset in the exchange. It includes standard ERC20 functionalities such as minting, transferring, and approving tokens.

## Contracts

### V1Exchange.sol

- **Functions**:
  - `addLiquidity(uint256 _tokenAmount)`: Adds liquidity to the exchange.
  - `ethToTokenSwap(uint256 _minTokens)`: Swaps ETH for tokens.
  - `tokenToEthSwap(uint256 tokenAmount, uint256 minimumEth)`: Swaps tokens for ETH.
  - `removeLiquidity(uint256 _amount)`: Removes liquidity from the exchange.
  - `tokenToTokenSwap(uint256 _tokensSold, uint256 _minTokensBought, address _tokenAddress)`: Swaps one token for another.

### V1Version.sol

- **Functions**:
  - `constructor(string memory name, string memory symbol, uint256 initialSupply)`: Initializes the token with a name, symbol, and initial supply.

## Deployment Scripts

The repository includes deployment scripts for deploying the `V1Version` token and the `V1Exchange` contract. These scripts are located in the `script` directory.

- **DeployV1Version.s.sol**: Deploys the `V1Version` token.
- **DeployV1Exchange.s.sol**: Deploys the `V1Exchange` contract with the token address.

## Testing

The smart contracts include tests to ensure functionality and correctness. The tests are located in the `test` directory and cover various scenarios, including adding liquidity, swapping tokens, and removing liquidity.

## Requirements

- [Foundry](https://book.getfoundry.sh/) for building and testing the contracts.
- Solidity version ^0.8.18.

## License

This project is licensed under the MIT License.