// SPDX-License-Identifier: MIT
pragma solidity 0.8.8;

import "./GambleContract.sol";
import "./interfaces/iVRFV2WrapperInterface.sol";

contract ManagerContract {
    //-------------------------------------other contracts start ---------------------------------------------

    //-------------------------------------other contracts end -----------------------------------------------

    //---------------------------------variables start---------------------------------------------------

    GambleContract[] private s_gambleContracts;
    uint32 private constant callBackGasLimit = 57800; //57646

    //-------------------------------variables end-----------------------------------------------------
    constructor() {}

    //-------------------------------------functionalities start---------------------------------------

    function createGambleOffer() public payable {
        GambleContract newContract = new GambleContract{value: msg.value}(
            msg.sender,
            msg.value
        );
        s_gambleContracts.push(newContract);
    }

    //-------------------------------------functionalities end---------------------------------------

    //-------------------------------------getters------------------------------------------------

    function getGambleContracts()
        public
        view
        returns (GambleContract[] memory)
    {
        uint256 count = s_gambleContracts.length;
        GambleContract[] memory list = new GambleContract[](count);
        for (uint i = 0; i < count; i++) {
            list[i] = s_gambleContracts[i];
        }
        return list;
    }

    function viewGambleContracts(uint256 index)
        public
        view
        returns (GambleContract)
    {
        return s_gambleContracts[index];
    }
}
