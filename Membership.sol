// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './Publication.sol';

contract Membership {
    uint index = 0;

    address addressInterface;
    InterfacePublication P = InterfacePublication(addressInterface);

    function setAddress(address _addressInterface) external {
        addressInterface = _addressInterface;
    }

    function getClientId(address _clientAddr) public view  returns (uint) {
        return P.getIdUser(_clientAddr);
    }

    function getClientLvl(uint clientId) public view  returns (uint) {
        uint[] memory tmp = P.getProgress(clientId);
        return tmp[tmp.length - 1];
    }

    function newClient(address _clientAddr) public {
        P.subWrite(_clientAddr, index);
        index += 1;
    }
}