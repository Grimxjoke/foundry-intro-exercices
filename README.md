# foundry-sch-exercises-part-1

Foundry version of SCH course exercises - Part 1

## Running the tests

1. General command:`forge test --match-contract {Contract_Name}`
2. Example: `forge test --match-contract TestERC201`
3. Forking Mainnet:
   `forge test --fork-url $ETH_RPC_URL --fork-block-number $BLOCK_NUMBER --match-contract {Contract_Name}`
4. Verbose Command: If you would like to know all the steps that occurred during the running of the test then append `-vvvvv` to the commands

## Progress

1. :white_check_mark: ERC20
2. :white_check_mark: ERC721
3. :white_check_mark: Randomness Vulnerabilities
4. :white_check_mark: Arithmetic Overflows and Underflows
5. :white_check_mark: Phishing Attacks
6. :eight_spoked_asterisk: Reentrancy Attacks
7. :white_check_mark: Access Control Vulnerabilities
