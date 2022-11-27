const { ethers } = require("hardhat");

const converterAddress = "0x373CAC07Be6a672BA1E91d982f2f7959f1813f68";
const gambleCOntractAddress = "0x284ed8386cca516aeda30e46b010da2dc583a915";

async function main() {
  const signers = await ethers.getSigners();
  const player1 = signers[1];
  const player2 = signers[2];

  let balance = await player1.getBalance();
  console.log("Player1 ETH balance");
  console.log(ethers.utils.formatEther(balance));

  balance = await player2.getBalance();
  console.log("Player2 ETH balance");
  console.log(ethers.utils.formatEther(balance));

  balance = await ethers.provider.getBalance(gambleCOntractAddress);
  console.log("Gamble Contract ETH balance");
  console.log(ethers.utils.formatEther(balance));

  balance = await ethers.provider.getBalance(converterAddress);
  console.log("Converter ETH balance");
  console.log(ethers.utils.formatEther(balance));
}

main()
  .then(() => {
    process.exit(0);
  })
  .then((e) => {
    console.error(e);
    process.exit(1);
  });
