# foundry-sch-exercises-part-1

Foundry version of SCH course exercises - Part 1

## Running the tests

1. General command:
   `forge test --match-contract {Contract_Name}`
   Example: `forge test --match-contract TestERC201`
2. Forking Mainnet:
   `forge test --fork-url $ETH_RPC_URL --fork-block-number $BLOCK_NUMBER --match-contract {Contract_Name}`
3. Verbose Command: If you would like to know all the steps that occurred during the running of the test then append `-vvvvv` to the commands

## Progress

- [x] ERC20
- [x] ERC721
- [x] Randomness Vulnerabilities
- [ ] Arithmetic Overflows and Underflows
- [ ] Phishing Attacks
- [ ] Reentrancy Attacks
- [ ] Access Control Vulnerabilities
