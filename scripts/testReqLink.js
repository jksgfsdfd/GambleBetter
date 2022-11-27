const { ethers } = require("hardhat");

const offerContractAddress = "0x284eD8386ccA516aeda30E46b010da2dc583a915";

const REQUEST_CONFIRMATIONS = 3;
const CALLBACKGASLIMIT = 57846;
const NUM_WORDS = 1;

async function main() {
  const signers = await ethers.getSigners();
  const signer = signers[2];
  const offerContract = await ethers.getContractAt(
    "GambleContract",
    offerContractAddress,
    signer
  );
  const tx = await offerContract.makeRequest();
  const receipt = await tx.wait(1);
  console.log(receipt.events[0].args.neededLinkTokens);
}

main()
  .then(() => {
    process.exit(0);
  })
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });
