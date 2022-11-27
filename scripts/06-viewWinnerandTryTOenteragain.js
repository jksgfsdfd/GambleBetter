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
  const winner = await offerContract.viewWinner();
  console.log(winner);

  const tx = await offerContract.enterGamble(4, {
    value: ethers.utils.parseEther("300"),
  });
  await tx.wait(1);
  //add a winner variable to gamblecontract
}

main()
  .then(() => {
    process.exit(0);
  })
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });
