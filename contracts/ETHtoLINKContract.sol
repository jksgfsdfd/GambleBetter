// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.8;

import "./interfaces/LinkTokenInterface.sol";
import "./interfaces/iAggregatorV3Interface.sol";

contract ETHtoLink {
    //----------------------------------------interacting contracts start-------------------------------------
    LinkTokenInterface private constant LINK =
        LinkTokenInterface(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);
    AggregatorV3Interface private constant priceFeed =
        AggregatorV3Interface(0xb4c4a493AB6356497713A78FFA6c60FB53517c63);
    //---------------------------------------interacting contracts end-------------------------------------

    //--------------------variables start-------------------------------
    address payable private immutable i_owner;

    //-----------------variables end-----------------------------------

    constructor() {
        i_owner = payable(msg.sender);
    }

    //------------------------------functionalities start-------------------------

    function convertETHtoLINK() public payable {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        uint8 decimals = priceFeed.decimals();
        uint256 requiredLink = uint256(
            (int256((10**decimals) * msg.value) / price)
        );
        bool success = LINK.transfer(msg.sender, requiredLink);
        require(success, "Couldnt transfer ETH");
    }

    function withdrawETH() public {
        require(msg.sender == i_owner, "only owner can withdraw");
        (bool success, ) = i_owner.call{value: address(this).balance}("");
        require(success, "couldn't sent eth");
    }

    function convertLINKtoETH(uint256 amount, address payable reciever) public {
        require(
            LINK.allowance(msg.sender, address(this)) >= amount,
            "Please approve tokens first"
        );
        LINK.transferFrom(msg.sender, address(this), amount);
        (, int256 price, , , ) = priceFeed.latestRoundData();
        uint8 decimals = priceFeed.decimals();
        uint256 requiredETH = (uint256(price) * amount) / (10**decimals);

        (bool success, ) = reciever.call{value: requiredETH}("");
        require(success, "Couldn't transfer ETH");
    }

    //---------------------------functionalities end-----------------------------
}
