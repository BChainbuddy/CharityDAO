// SPDX-License-Identifier:MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

contract FundRaiser is Ownable {
    error charityNameToLong();
    error addressNotAllowed();

    uint256 public s_charityFund; //uint256 because the charity fund can become very big

    event fundsSentToCharity(address indexed _address, uint256 _amount);
    event charityFunded(address indexed _address, uint256 _amount);
    event newCharityAllowed(address indexed _address, bytes32 _name);

    struct allowedCharity {
        uint256 charityBalance;
        bytes32 charityName;
        bool exists;
    }

    mapping(address => allowedCharity) public allowedCharities;

    //FUNCTION TO SEND MONEY TO A CHARITY, OWNABLE BY DAO
    function sendToCharity(address _address, uint256 _amount) public onlyOwner {
        if (!allowedCharities[_address].exists) {
            revert addressNotAllowed();
        }
        s_charityFund -= _amount;
        allowedCharities[_address].charityBalance += _amount;
        emit fundsSentToCharity(_address, _amount);
    }

    //FUNCTION TO ALLOW NE CHARITY, OWNABLE BY DAO
    function allowNewCharity(string memory _charityName, address _address) public onlyOwner {
        if (bytes(_charityName).length > 24) {
            revert charityNameToLong();
        }
        allowedCharities[_address].exists = true;
        allowedCharities[_address].charityName = bytes32(bytes(_charityName));
        emit newCharityAllowed(_address, bytes32(bytes(_charityName)));
    }

    //ADD TO A CHARITY FUND, DONT GET THE GOVERNANCE TOKENS IF NOT CALLED FROM A FUNDTOKEN
    function addToCharityFund() public payable {
        s_charityFund += msg.value;
        emit charityFunded(msg.sender, msg.value);
    }

    //SEE THE CHARITY FUND
    function checkCharityFundValue() public view returns (uint256) {
        return s_charityFund;
    }

    //SEE THE CHARITY NAME
    function checkCharityName(address _address) public view returns (bytes32) {
        if (!allowedCharities[_address].exists) {
            revert addressNotAllowed();
        }
        return allowedCharities[_address].charityName;
    }

    //CHECK ALLOWED CHARITY FUNDING TILL NOW
    function checkAllowedCharityFunding(address _address) public view returns (uint256) {
        if (!allowedCharities[_address].exists) {
            revert addressNotAllowed();
        }
        return allowedCharities[_address].charityBalance;
    }

    //FALLBACK FUNCTION(called if the function called doesn't exist, contains msg.data)
    fallback() external payable {
        addToCharityFund();
    }

    //RECEIVE FUNTCION(called if the function called doesn't exits, doesnt contain msg.data)
    receive() external payable {
        addToCharityFund();
    }
}
