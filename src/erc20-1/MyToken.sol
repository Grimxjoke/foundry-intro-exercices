// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    address private owner;

    constructor() ERC20("EAGLE", "EGL") {
        owner = msg.sender;
    }

    function mint(address _acc, uint256 _amount) public {
        require(owner == msg.sender, "Only owner can mint new EGL Tokens!!!");
        _mint(_acc, _amount);
    }
}
