// SPDX-License-Identifier: MIT

pragma solidity >=0.6.6 <0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {
    using SafeMathChainlink for uint256;
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function fund() public payable {
        // send me a minimum of $50 USD
        uint256 minUSD = 50 * 10**18; //gwei conversion
        require(
            getConversionRate(msg.value) >= minUSD,
            "Give me at least $50!"
        );
        addressToAmountFunded[msg.sender] += msg.value;
        // oracle problem: non-deterministic functions (api-calls, rand, etc) will not reach consensus
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        // chainlink eth/usd address
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
        // (uint80 roundId,
        // int256 answer,
        // uint256 startedAt,
        // uint256 updatedAt,
        // uint80 answeredInRound) = priceFeed.latestRoundData();
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        return uint256(answer);
    }

    function getConversionRate(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 100000000;
        return ethAmountInUsd;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can use this function");
        _;
    }

    // function withdraw() payable public {
    function withdraw() public payable onlyOwner {
        // require(msg.sender == owner);
        msg.sender.transfer(address(this).balance);
        for (uint256 i = 0; i < funders.length; i++) {
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }
        // could also reinitialize
        funders = new address[](0);
    }
}
