# SCH Exercises Part 2 [Foundry Version]

![image](https://user-images.githubusercontent.com/91771249/227430056-d7971b2d-d707-49df-a10e-93c4118c76a6.png)
_{Credit: Paradigm}_

- For those of you who would like to get started with Foundry, you can perform the exercises of Foundry version after completing the hardhat version. I've tried to keep the files similar to the hardhat version so you can understand what a particular line of code in Foundry does 🔥 This will help you to learn Foundry in a very practical way 😀

- Once you are familiar with foundry tests, try to implement them yourself 💪.

## Quick Setup

> `git clone https://github.com/johnny-sch-course/foundry-sch-exercises-part-2`

> `cd foundry-sch-exercises-part-2`

> `forge init --force`

## Running the tests

- General command:

  > `forge test --match-contract {Contract_Name}`

  > `forge test --match-contract TestERC201`

- Forking Mainnet:

  > `forge test --fork-url $ETH_RPC_URL --fork-block-number $BLOCK_NUMBER --match-contract {Contract_Name}`

- To see step-wise execution of your exploit, append following to the commands
  > `-vvvvv`

## Status

1.  🟢 DEX
2.  ⚪ Money Markets
3.  ⚪ Replay Attacks
4.  ⚪ Flash Loans & Flash Swaps
5.  ⚪ Flash Loan Attacks
6.  ⚪ DoS Attacks
7.  ⚪ Sensitive On-Chain Data
8.  ⚪ Unchecked Returns
9.  ⚪ Frontrunning
10. ⚪ DAO & Governance Attacks
11. ⚪ Oracle Manipulation
12. ⚪ Call Attacks
