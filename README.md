# SCH Exercises Part 1 [Foundry Version]

![image](https://user-images.githubusercontent.com/91771249/227430056-d7971b2d-d707-49df-a10e-93c4118c76a6.png)
*{Credit: Paradigm}*
- For those of you who would like to get started with Foundry, you can perform the exercises of Foundry version after completing the hardhat version. I've tried to keep the files similar to the hardhat version so you can understand what a particular line of code in Foundry does 🔥 This will help you to learn Foundry in a very practical way 😀

- Once you are familiar with foundry tests, try to implement them yourself 💪. You will learn a lot like forking, importing & deploying contracts directly (and also using only contract's bytecode) and much more...

## Quick Setup

> `git clone https://github.com/johnny-sch-course/foundry-sch-exercises-part-1`

> `cd foundry-sch-exercises-part-1`

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

1. :white_check_mark: ERC20
2. :white_check_mark: ERC721
3. :white_check_mark: Randomness Vulnerabilities
4. :white_check_mark: Arithmetic Overflows and Underflows
5. :white_check_mark: Phishing Attacks
6. :white_check_mark: Reentrancy Attacks
7. :white_check_mark: Access Control Vulnerabilities
