const { ethers } = require("hardhat");

//change the addresses accordingly
const LINKTOkenAddress = "0x326C977E6efc84E512bB9C30f76E30c160eD06FB";
const converterAddress = "0x373CAC07Be6a672BA1E91d982f2f7959f1813f68";
const vrfwrapperAddress = "0x708701a1DfF4f478de54383E49a627eD4852C816";
const gambleCOntractAddress = "0x284ed8386cca516aeda30e46b010da2dc583a915";

async function main() {
  const signers = await ethers.getSigners();
  const signer = signers[2];

  const LINKContract = await ethers.getContractAt(
    "LinkTokenInterface",
    LINKTOkenAddress,
    signer
  );

  let balance = await LINKContract.balanceOf(converterAddress);
  console.log("Converter link balance");
  console.log(balance);

  balance = await LINKContract.balanceOf(vrfwrapperAddress);
  console.log("vrfWrapper link balance");
  console.log(balance);

  balance = await LINKContract.balanceOf(gambleCOntractAddress);
  console.log("Gamble Contract link balance");
  console.log(balance);

  balance = await LINKContract.balanceOf(signer.address);
  console.log("singer[2] Contract link balance");
  console.log(balance);
}

main()
  .then(() => {
    process.exit(0);
  })
  .then((e) => {
    console.error(e);
    process.exit(1);
  });
