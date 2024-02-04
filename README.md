# Lightcurve

The purpose of this repository is to find the vulnerabilities of a contract in Solidity, resolve them and optimise it, leaving a brief `report`. Also to create a `multichain module` with TypeScript and a `custom module` in Solidity both using Biconomy.

# Tasks

`Problem1`:

- i) Find the vulnerabilities in the contract [VulnerableContract.sol](https://github.com/luislucena16/lightcurve-v2/blob/4026f5d8c11b809be2ffd5c9f48c03350ea89c2f/poc/VulnerableContract.sol) and explain each of them.
- ii) Update the smart contract while addressing vulnerabilities.

`Problem2`:

This problem involves Account abstraction, therefore it is expected from the candidates to have
some preliminary knowledge of account abstraction.

Please use [biconomy sdk](https://docs.biconomy.io/) for following tasks:
- i) Deploy a biconomy smart account on multiple chains with the same address. It should allow
EOA to sign multiple user operations (one per chain) on multiple chains with a single ECDSA
signature. After the deployment, share the address of the deployed contracts.
- ii) Write a biconomy module (or alternatively, in pseudo-code) which has the ability to:
- a) Abort the transaction if a user spending amount crosses the limit value set by the user.
- b) Limit the number of transactions per day for a user.

# Solution

`Solution N.1`

- The optimisation and audit of the [VulnerableContract.sol](https://github.com/luislucena16/lightcurve-v2/blob/4026f5d8c11b809be2ffd5c9f48c03350ea89c2f/poc/VulnerableContract.sol) contract are in the [contracts](https://github.com/luislucena16/lightcurve-v2/blob/41bc7f68f3e5522180536b5d30d4fd4168d209df/contracts) folder, all those starting with the `Fix` prefix and also the [lightcurve-report.pdf](https://github.com/luislucena16/lightcurve-v2/blob/41bc7f68f3e5522180536b5d30d4fd4168d209df/contracts/lightcurve-report.pdf).


`Solution N.2`

- Biconomy SDK was used to make use of the `Multichain Validation Module`, in this case it was done with NFTs, a single signature for multiple transactions in different chains, one per chain:
```bash
Smart Account Address of Mumbai: 0x891ca07632BCa8c5f43669e07A7BbDe76FEEE0d3 
Polygon Mumbai Transaction: https://mumbai.polygonscan.com/tx/0x42ab20b08f87f66d3fe77fa74722bfdbe110e9ff16a1471527ffc390c9d84891
```
```bash
Smart Account Address of Base Goerli: 0x891ca07632BCa8c5f43669e07A7BbDe76FEEE0d3
Base Goerli Transaction: https://goerli.basescan.org/tx/0xc11b8622ca5fc7a85fa0f78ce2b190af8ead7e69a34c61f1f1dc34c1daf219f6
```

- The custom module written in Solidity as `PoC` was added certain contracts in order to test the required functionality, among which are:

1. Harness: contracts that serve as mocks to recreate pocs with specific situations. In this case we can find [Biconomy Harness](https://github.com/luislucena16/lightcurve-v2/blob/5f0497c5242a7d3e4915a870f273988863688af0/contracts/biconomy/harness) and [Open Zeppelin Harness](https://github.com/luislucena16/lightcurve-v2/blob/139467841e248bc70abc2446b2801d12a54de2fe/contracts/oz-harness). In order to avoid errors when performing the `PoC`.

2. The error management of these contracts was persevered, only in order to modify what was needed.

3. The `BiconomyPoC.sol` custom module can be found [here](https://github.com/luislucena16/lightcurve-v2/blob/ec92d94c150d6cdeb0f5445aab679601eb7eb26a/contracts/biconomy/BiconomyPoC.sol).

`Note`: this contract is only for `PoC` use, it can be optimised and audited, but that was not the focus!

- a) Abort the transaction if a user spending amount crosses the limit value set by the user:
 ```bash
    // Check spending limit
    // This condition was created to use in the PoC (userSpendingLimits, spentAmount)
    if (userSpendingLimits[sender] > 0 && userSpendingLimits[sender] < userOp.spentAmount) {
       revert("User spending limit exceeded");
   }
```

This code snippet checks if the current transaction spending exceeds the limit set by the user. If so, the transaction will be aborted and reverted with the message "User spending limit exceeded".

- b) Limit the number of transactions per day for a user.
```bash
    // Check transaction limit per day
    // This condition was created to use in the PoC (userTransactionCount, TRANSACTION_LIMIT, event TransactionLimitExceeded)
    if (userTransactionCount + 1 > TRANSACTION_LIMIT) {
       emit TransactionLimitExceeded(sender,userTransactionCount + 1, TRANSACTION_LIMIT);
       revert("Transaction limit exceeded");
    }
    // Increment transaction count for the user
    userTransactionCount.increment();
```

Here, a check is made to see if the user's current number of transactions for the day exceeds the set limit (TRANSACTION_LIMIT). If so, a TransactionLimitExceeded event is issued and the transaction is rolled back with the message "Transaction limit exceeded". After this, the transaction counter is incremented.

`Note`: as converted by `email` the code is a poc and currently compiles with both frameworks.

- Now comes the technical part! Let's go! ✨

## Run locally

#### Clone the project

```bash
git clone https://github.com/luislucena16/lightcurve.git
```

#### Go to the project directory

```bash
cd lightcurve
```

#### Install dependencies

- Using `npm`:

```bash
npm install
```

`Note`: this repository is dynamic and has the ability to work with Foundry and/or Hardhat, whichever you prefer.

# Run with Hardhat

- Compile contracts:

```bash
npx hardhat compile
```

- Clean cache:

```bash
npx hardhat clean
```

# Run with Foundry

#### Install foundry (if you have it installed, skip this step and go to `Compile contracts`)

```bash
curl -L https://foundry.paradigm.xyz | bash
```

# Running foundryup

- Run:

```bash
foundryup
```

- Running again:

```bash
npm install
```

- To get the submodules, run:

```bash
git submodule update --init --recursive
```

- Compile contracts:

```bash
forge build
```

- Clean cache:

```bash
forge clean
```

# Running Biconomy SDK

#### Go to the project directory

```bash
cd biconomy-sdk
```

#### Install dependencies

- Using `npm`:

```bash
npm install
```

### Create `.env` file

- Add your [PRIVATE_KEY](https://github.com/luislucena16/lightcurve-v2/blob/main/biconomy-sdk/.env.example) this is just to create an instance with the `ethers.Wallet` method.
```bash
PRIVATE_KEY="a30...68x9"
```

### Run Biconomy Modules

- Make sure you are in the [biconomy-sdk](https://github.com/luislucena16/lightcurve-v2/blob/main/biconomy-sdk) directory and run:

```bash
npm run dev
```

This will raise a `nodemon` that will run and execute the `Multichain Validation Module` with the necessary requirements, you will see all the details as the addresses of the `Smart Accounts` and the two links in the transaction of both networks in your terminal.

This was the end! :)

# Made with ❤️ by Luis
