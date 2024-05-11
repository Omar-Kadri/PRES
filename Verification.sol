// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import './Publication.sol';

contract Verification {
    mapping(uint => uint[]) private ALL_GAME_STATE;

    address addressInterface;
    InterfacePublication P = InterfacePublication(addressInterface);

    function setAddress(address _addressInterface) external {
        addressInterface = _addressInterface;
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
        uint[] memory progress = P.getProgress(id_user);
        if (progress.length == 1) {
            return true;
        }
        for (uint i = 0; i < progress.length - 1; i++) {
            if (!canReachLevel(progress[i], progress[i+1])) {
                return false;
            }
        }
        return true;
    }

    function advance(uint current_Lv,uint next_Lv) private view returns (bool){
        uint[] memory progress = P.getProgress(id_user);
        if (canReachLevel(current_Lv, next_Lv)) {
            return true;
        }
        else {
            return false;
        } 
    }

    function verify_path(uint id_user, uint current_Lv, uint next_Lv) public{

        if((check(id_user, current_Lv) == true) && (advance(id_user, current_Lv, next_Lv) == true)){
            P.verifWrite(id_user, next_Lv);
        }
    }

    function getList(uint key) public view returns (uint[] memory) {
        return ALL_GAME_STATE[key];
    }
}
