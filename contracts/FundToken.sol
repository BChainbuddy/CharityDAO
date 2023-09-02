// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "../contracts/FundRaiser.sol";

contract FundToken is ERC20Votes {
    FundRaiser public fundraiser;

    constructor(
        address _fundraiser
    ) ERC20("GovernanceToken", "GOV") ERC20Permit("GovernanceToken") {
        fundraiser = FundRaiser(payable(_fundraiser));
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20Votes) {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount) internal override(ERC20Votes) {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount) internal override(ERC20Votes) {
        super._burn(account, amount);
    }

    function sendFunds() public payable {
        fundraiser.addToCharityFund{value: msg.value}();
        _mint(msg.sender, msg.value);
    }

    function getFundRaiserAddress() public view returns (FundRaiser) {
        return fundraiser;
    }

    fallback() external payable {
        sendFunds();
    }

    receive() external payable {
        sendFunds();
    }
}
