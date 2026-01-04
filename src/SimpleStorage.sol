// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

// pragma solidity ^0.8.0;
// pragma solidity >=0.8.0 <0.9.0;

contract SimpleStorage {
    uint256 num;

    struct Person {
        string name;
        uint256 num;
    }

    Person[] public listOfPeople;

    mapping(string => uint256) public nameToNum;

    function store(uint256 _num) public {
        num = _num;
    }

    function retrieve() public view returns (uint256) {
        return num;
    }

    function addPerson(string memory _name, uint256 _num) public {
        listOfPeople.push(Person(_name, _num));
        nameToNum[_name] = _num;
    }
}
