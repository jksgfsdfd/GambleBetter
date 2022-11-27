# GambleBetter
Collection of contracts to make a one-vs-one gambling app.

The contracts was deployed and tested with a local hardhat fork of Goerli testnet.

This a brief breakdown about the project:

How to gamble?

Any user who wish to gamble has two options: 

  1. Create a new offer contract by interacting with the manager contract : This can be done by invoking the createGambleOffer() function of the manager contract with how much ever Ether the user wishes to gamble.

  2. Gamble in an offer contract that was created by another user : An user who have followed 1. will create a new contract representing his offer. Any user who is willing to gamble can invoke the enterGamble() function of that contract with a guess(0 or 1) and the required Ether.
  
 How it works?
 
 The offer contract created uses ChainLink VRF to get a random number which is then mapped to either 0 or 1. The contract then sends all its Ether to the winner. Since we wish to make the LinkToken payments associated with the users itself, direct funding method is used for ChainLink VRF. The conversion between ETH/LINK is calculated using ChainLink price feed and since Uniswap was unstable for ETH/LINK conversion in the Goerli Tesetnet, there is another contract used which converts Ether to Link.   

