# Smart Contract Wallet

This repository contains a Solidity-based smart contract wallet designed to securely manage Ether transactions and control fund transfers. The wallet features multi-signature ownership, guardian approval mechanisms, and customizable allowances for authorized accounts.

## Features

- **Ownership Control**: The wallet has a designated owner who controls key actions, such as setting allowances and transferring ownership.
- **Guardian System**: Guardians can be added by the owner to help safeguard the wallet. A new owner can only be set if a majority of guardians approve.
- **Allowance System**: The owner can set allowances for specific addresses, allowing them to transfer a limited amount of funds.
- **Fallback and Receive Functions**: The contract is able to receive Ether through the default payable functions.

## Smart Contracts Overview

### 1. **Consumer Contract**
This contract allows for basic interactions with Ether, providing functions to deposit and check the contract's balance.

#### Functions:
- `getBalance()`: Returns the current balance of the contract.
- `deposit()`: Allows Ether to be deposited into the contract.

### 2. **SmartContractWallet**
The core of the wallet functionality. It allows the owner to control the wallet, set allowances for specific addresses, and transfer ownership based on guardian approvals.

#### Key Components:
- **Owner**: The wallet has a designated owner, initially set to the contract deployer.
- **Guardians**: A group of addresses that can help safeguard the wallet and propose a new owner.
- **Allowances**: Authorized addresses can be given permission to send a specific amount of Ether from the wallet.

#### Functions:
- `setGuardian(address _guardian, bool _isGuardian)`: Allows the owner to add or remove a guardian.
- `proposeNewOwner(address payable _newOwner)`: Allows a guardian to propose a new owner, requiring approval from a set number of guardians.
- `setAllAllowance(address _for, uint _amount)`: The owner can set or modify the allowance for specific addresses.
- `transfer(address payable _to, uint _amount, bytes memory _payload)`: Allows the owner or authorized addresses to transfer Ether to other accounts, within the limit of their allowance.
- `receive() external payable`: Enables the wallet to receive Ether directly.

## How It Works

1. **Owner Control**: The wallet is initialized with the contract deployer as the owner. The owner has full control over the wallet’s funds and can grant allowances to other addresses.
   
2. **Guardian Approval for Ownership Change**: Guardians can be set by the owner to provide security. If the owner is compromised or unable to manage the wallet, a new owner can be proposed by the guardians. If enough guardians approve (3 in this case), the ownership is transferred.

3. **Allowance System**: The owner can assign a specific Ether allowance to authorized addresses. These addresses can then transfer funds up to their allowance, while the owner retains full control.

4. **Ether Transfers**: Any address with sufficient allowance can send Ether from the wallet, subject to a successful call. The wallet can also receive Ether directly.

## Security Considerations

- **Ownership Management**: Only the owner can set or remove guardians, and allowances are also managed by the owner.
- **Guardian Consensus**: A minimum number of confirmations from guardians is required to reset ownership.
- **Allowance Checks**: The contract ensures that no more Ether can be sent than the assigned allowance for a given address.

## How to Use

1. **Deployment**: Deploy the `SmartContractWallet` contract using a Solidity-compatible development environment like Remix, Hardhat, or Truffle.
2. **Interact with the Contract**:
   - Set allowances for specific addresses.
   - Transfer Ether either as the owner or from addresses with allowances.
   - Guardians can propose and vote for a new owner.

## Prerequisites

- Solidity 0.8.0 or higher.
- A development environment like Remix or Hardhat.
- Metamask or any other Ethereum wallet for deployment and interaction.

## License

This project is licensed under the MIT License.

---
