// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface InterfacePublication {
    function getIdUser(address _clientAddr) external view  returns (uint);
    function getProgress(uint idUser) external view returns (uint[] memory);
    function subWrite(address _clientAddr, uint i) external;
    function verifWrite(uint id_user, uint nextLv) external;
}

contract Publication {
    mapping(address => uint) public clientList;
    mapping(uint => uint[]) public progress;

    function getIdUser(address _clientAddr) external view  returns (uint) {
        return clientList[_clientAddr];
    }

    function getProgress(uint idUser) external view returns (uint[] memory) {
        return progress[idUser];
    }
    
    function verifWrite(uint id_user, uint nextLv) external {
        progress[id_user].push(nextLv);
    }

    function subWrite(address _clientAddr, uint i) external {
        clientList[_clientAddr] = i;
        progress[i].push(1);
    }
}
