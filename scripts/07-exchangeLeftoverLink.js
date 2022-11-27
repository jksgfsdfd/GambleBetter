const { ethers } = require("hardhat");

const offerContractAddress = "0x284eD8386ccA516aeda30E46b010da2dc583a915";

async function main() {
  const signers = await ethers.getSigners();
  const signer = signers[2];
  const offerContract = await ethers.getContractAt(
    "GambleContract",
    offerContractAddress,
    signer
  );
  const tx = await offerContract.takeleftOverLink();
  const receipt = await tx.wait(1);
}

main()
  .then(() => {
    process.exit(0);
  })
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });
