// SPDX-License-Identifier: MIT
pragma solidity 0.8.8;

import "./interfaces/iVRFV2WrapperInterface.sol";
import "./interfaces/iAggregatorV3Interface.sol";
import "./interfaces/iETHtoLINKInterface.sol";
import "./interfaces/LinkTokenInterface.sol";

contract GambleContract {
    //----------------------------other contract interactions start-------------------------
    LinkTokenInterface private constant LINK =
        LinkTokenInterface(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);

    VRFV2WrapperInterface private constant vrfwrapper =
        VRFV2WrapperInterface(0x708701a1DfF4f478de54383E49a627eD4852C816);

    AggregatorV3Interface private constant priceFeed =
        AggregatorV3Interface(0xb4c4a493AB6356497713A78FFA6c60FB53517c63);

    ETHtoLinkInterface private constant ethtolink =
        ETHtoLinkInterface(0x373CAC07Be6a672BA1E91d982f2f7959f1813f68); // change address
    //----------------------------other contract interactions end-------------------------

    //------------------------------variables start------------------------------------------

    enum gambleStates {
        OPEN,
        FINDING,
        CANCELLED,
        FINISHED
    }

    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant CALLBACKGASLIMIT = 98000;
    uint32 private constant NUM_WORDS = 1;

    address private immutable i_offerMaker;
    uint256 private immutable i_offerAmount;

    address private s_gambler;
    uint8 private s_guess;

    address payable private s_winner;
    gambleStates private s_gambleState;

    //------------------------------variables end---------------------------------------------

    constructor(address offerMaker, uint offerAmount) payable {
        i_offerMaker = offerMaker;
        i_offerAmount = offerAmount;
        s_gambleState = gambleStates.OPEN;
    }

    //--------------------------functionalities start-----------------------------------------------

    /**
     * lets any person to gamble
     */

    function enterGamble(uint8 guess) public payable onlyOpen {
        if (msg.value < i_offerAmount) {
            revert("pay enough amount");
        }

        s_gambler = msg.sender;
        s_guess = (guess) % 2;

        int256 neededLinkWei = int256(
            vrfwrapper.calculateRequestPrice(CALLBACKGASLIMIT)
        );
        emit neededLink(neededLinkWei);
        uint256 neededWei = uint256(calcETHforLINK(neededLinkWei));

        if (msg.value < neededWei) {
            revert("no use of gambling...money will go for vrf");
        }

        // neededWei = (neededWei * 15) / 10;
        neededWei = neededWei + 0.01 ether;
        getLINK(neededWei);
        //s_gambleState = gambleStates.LOCKED;
        //  gamble();
        uint256 reqId = requestRandomness(
            CALLBACKGASLIMIT,
            REQUEST_CONFIRMATIONS,
            NUM_WORDS
        );
        s_gambleState = gambleStates.FINDING;
    }

    /*  function gamble() public onlyLocked {
        uint256 reqId = requestRandomness(
            CALLBACKGASLIMIT,
            REQUEST_CONFIRMATIONS,
            NUM_WORDS
        );
        s_gambleState = gambleStates.FINDING;
    } */

    function getLINK(uint256 neededWei) internal {
        ethtolink.convertETHtoLINK{value: neededWei}();
    }

    function calcETHforLINK(int256 neededLinkWei)
        private
        view
        returns (int256)
    {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        uint8 decimals = priceFeed.decimals();
        int256 requiredWei = ((price) * neededLinkWei) / int256(10**(decimals));
        return requiredWei;
    }

    function requestRandomness(
        uint32 _callbackGasLimit,
        uint16 _requestConfirmations,
        uint32 _numWords
    ) internal returns (uint256 requestId) {
        uint256 reqprice = vrfwrapper.calculateRequestPrice(_callbackGasLimit);
        emit requestingLINK(reqprice);
        bool success = LINK.transferAndCall(
            address(vrfwrapper),
            reqprice,
            abi.encode(_callbackGasLimit, _requestConfirmations, _numWords)
        );
        return vrfwrapper.lastRequestId();
    }

    function fulfillRandomWords(uint256, uint256[] memory randomWords) public {
        uint random = (randomWords[0]) % 2;
        if (random == s_guess) {
            s_winner = payable(s_gambler);
        } else {
            s_winner = payable(i_offerMaker);
        }

        (bool success, ) = s_winner.call{value: address(this).balance}("");
        require(success, "ETH cant be transferred");
        s_gambleState = gambleStates.FINISHED;
        takeleftOverLink();
    }

    function rawFulfillRandomWords(
        uint256 _requestId,
        uint256[] memory _randomWords
    ) external {
        require(
            msg.sender == address(vrfwrapper),
            "only VRF V2 wrapper can fulfill"
        );
        fulfillRandomWords(_requestId, _randomWords);
    }

    function cancelOffer() public onlyOwner {
        address payable owner = payable(i_offerMaker);
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success, "ETH cant be transferred");
        s_gambleState = gambleStates.CANCELLED;
    }

    function takeleftOverLink() internal {
        uint256 balance = LINK.balanceOf(address(this));
        require(balance > 0, "No link left to transfer");
        bool success = LINK.approve(address(ethtolink), balance);
        require(success, "Couldn't transfer LINK");
        ethtolink.convertLINKtoETH(balance, s_winner);
    }

    //---------------------------------functionalities end------------------------------

    //----------------------------modifiers and errors start------------------------------

    //----------------------------modifiers and errors end------------------------------

    modifier onlyOwner() {
        require(
            msg.sender == i_offerMaker,
            "Only offer maker can cancel this offer"
        );
        _;
    }

    modifier onlyFinished() {
        require(
            s_gambleState == gambleStates.FINISHED,
            "Winner has not yet been found"
        );
        _;
    }

    modifier onlyOpen() {
        require(
            s_gambleState == gambleStates.OPEN,
            "Gamble offer is not open anymore"
        );
        _;
    }

    //---------------------events start--------------------------------------------
    event requestingLINK(uint256 reqprice);

    event neededLink(int256 neededLinkTokens);

    //----------------------------events end-----------------------------------------------

    //-------------------getters start-----------------------------------

    function viewOfferMaker() public view returns (address) {
        return i_offerMaker;
    }

    function viewOfferAmount() public view returns (uint256) {
        return i_offerAmount;
    }

    function viewGambler() public view returns (address) {
        return s_gambler;
    }

    function viewGuess() public view returns (uint8) {
        return s_guess;
    }

    function viewWinner() public view onlyFinished returns (address) {
        return s_winner;
    }

    function viewState() public view returns (gambleStates) {
        return s_gambleState;
    }
}
