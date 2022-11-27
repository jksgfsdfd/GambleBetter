const { ethers } = require("hardhat");

//address of the created offer contract
const offerContractAddress = "0x284eD8386ccA516aeda30E46b010da2dc583a915";

async function main() {
  const signers = await ethers.getSigners();
  const signer = signers[2];
  const offerContract = await ethers.getContractAt(
    "GambleContract",
    offerContractAddress,
    signer
  );
  const tx = await offerContract.enterGamble(1, {
    value: ethers.utils.parseEther("200"),
    gasLimit: 5000000,
  });
  const receipt = await tx.wait(1);
  console.log("first calculated needed link is");
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
