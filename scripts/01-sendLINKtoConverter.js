const { AbiCoder } = require("ethers/lib/utils");
const { ethers } = require("hardhat");

//address of LINK token contract
const LINKTOkenAddress = "0x326C977E6efc84E512bB9C30f76E30c160eD06FB";

//address of the deployed converter contract
const converterAddress = "0x373CAC07Be6a672BA1E91d982f2f7959f1813f68";

async function main() {
  const signers = await ethers.getSigners();
  const signer = signers[0];
  const amount = ethers.utils.parseEther("10");
  const LINKContract = await ethers.getContractAt(
    "LinkTokenInterface",
    LINKTOkenAddress,
    signer
  );

  let tx = await LINKContract.transfer(converterAddress, amount);

  await tx.wait(1);

  const balance = await LINKContract.balanceOf(converterAddress);
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
