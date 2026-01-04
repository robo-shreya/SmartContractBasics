//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {SimpleStorage} from "./SimpleStorage.sol";

contract StorageFactory {

    //variables - "type visibility name"

    SimpleStorage[] public listOfSimpleStorageContracts;
    // creating a list which will keep a record of addresses of already deployed SimpleStorage
    // instead of deploying a new SimpleStorage directly

    function createSimpleStorageContract() public {
        SimpleStorage newSimpleStorage = new SimpleStorage();
        listOfSimpleStorageContracts.push(
            newSimpleStorage
        );
    }

    function sfStore(
        uint256 _simpleStorageIndex,
        uint256 _simpleStorageNumber
    ) public {
        // in order to interact with other contracts, we need:
        // 1. Address 2. Function selector 

        listOfSimpleStorageContracts[_simpleStorageIndex].store(
            _simpleStorageNumber
        );
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        return listOfSimpleStorageContracts[_simpleStorageIndex].retrieve();
    }

}
