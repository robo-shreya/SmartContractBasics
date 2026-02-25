// getting funds
// withdraw funds by the owner of the contract
// set min funding value

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {
    AggregatorV3Interface
} from "node_modules/@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    // so basically we can use the functions from the library for all uint256 values
    using PriceConverter for uint256;

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;

    // Could we make this constant?
    /* constant values must be known at compile time however,
    msg.sender is only known at deployment time */

    address public /* immutable */ i_owner;
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;

    constructor() {
        i_owner = msg.sender;
    }

    // function marked payable can receive Ether via msg.value.

    function fund() public payable {
        // value of a transaction is accessible through the msg.value property
        // This property is part of the global object msg
        // It represents the amount of Wei transferred in the current transaction, where Wei is the smallest unit of Ether (ETH).
        // 1 ETH = 1e18 WEI = 1e9 GWEI

        require(msg.value.getConversionRate() >= MINIMUM_USD, "You need to spend more ETH!");
        //If the specified requirement is not met, the transaction will revert.

        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        // getting realtime price data from chainlink
        // BTC/ETH - 0x5fb1616F78dA7aFC9FF79e0371741a747D2a7F22
        // BTC/USD - 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }

    modifier onlyOwner() {
        // require(msg.sender == owner);
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }

    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);
        // // transfer
        // payable(msg.sender).transfer(address(this).balance);

        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        // call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \
    //         yes  no
    //         /     \
    //    receive()?  fallback()
    //     /   \
    //   yes   no
    //  /        \
    //receive()  fallback()

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
}
