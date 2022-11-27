// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.8;

interface ETHtoLinkInterface {
    function convertETHtoLINK() external payable;

    function convertLINKtoETH(uint256 amount, address payable reciever)
        external;
}
