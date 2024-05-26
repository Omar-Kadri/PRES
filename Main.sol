// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IPublication {
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

contract Membership {
    uint public index = 1;
    event Log(string message);

    address addressInterface;

    function setAddress(address _addressInterface) external {
        addressInterface = _addressInterface;
    }

    function getClientId(address _clientAddr) public view  returns (uint) {
        return IPublication(addressInterface).getIdUser(_clientAddr);
    }

    function getClientLvl(uint clientId) public view  returns (uint) {
        uint[] memory tmp = IPublication(addressInterface).getProgress(clientId);
        return tmp[tmp.length - 1];
    }

    function newClient(address _clientAddr) public {
        uint tmp = getClientId(_clientAddr);

        if (tmp != 0) {
            emit Log("Client Already registered");
        } else {
            IPublication(addressInterface).subWrite(_clientAddr, index);
            index += 1;
            emit Log("Client registered successfully");
        }
    }
}

contract Verification {
    mapping(uint => uint[]) private ALL_GAME_STATE;
    event Log(string message);


    address addressInterface;

    function setAddress(address _addressInterface) external {
        addressInterface = _addressInterface;
        ALL_GAME_STATE[1] = [2];
        ALL_GAME_STATE[2] = [3];
        ALL_GAME_STATE[3] = [4,5,6];
        ALL_GAME_STATE[4] = [7];
        ALL_GAME_STATE[5] = [8];
        ALL_GAME_STATE[8] = [9,10];
    }

    function canReachLevel(uint fromLevel, uint toLevel) private view returns (bool) {
        uint[] memory nextLvls = getList(fromLevel);
        //Intérer tout les niveaux accessibles à partir de fromLevel
        for (uint j = 0; j < nextLvls.length; j++) {
            // Si toLevel peut être atteint à partir de fromLevel, retourner true
            if (nextLvls[j] == toLevel) {
                return true; 
            }
        }
        return false; // Sinon, retourner false
    }

    function check(uint id_user, uint current_lvl) private view returns (bool) {
        uint[] memory progress = IPublication(addressInterface).getProgress(id_user);
        if (progress.length == 0) {
            return false;
        }
        if (progress.length == 1) {
            return true;
        }
        for (uint i = 0; i < progress.length - 1; i++) {
            if (!canReachLevel(progress[i], progress[i+1])) {
                return false;
            }
        }
        if (current_lvl == progress[progress.length - 1]) {
            return true;
        }
        return false;
    }

    function advance(uint current_Lv,uint next_Lv) private view returns (bool){
        if (canReachLevel(current_Lv, next_Lv)) {
            return true;
        }
        else {
            return false;
        } 
    }

    function verify_path(uint id_user, uint current_Lv, uint next_Lv) public{
        uint tmp = IPublication(addressInterface).getProgress(id_user).length;
        if (tmp == 0) {
            emit Log("Client not registered!");
        } else if ((check(id_user, current_Lv) == true) && (advance(current_Lv, next_Lv) == true)){
            IPublication(addressInterface).verifWrite(id_user, next_Lv);
            emit Log("Validation successful");
        } else {
            emit Log("Validation failed. Calling Conflict service ...");
        }
    }

    function getList(uint key) public view returns (uint[] memory) {
        return ALL_GAME_STATE[key];
    }
}
