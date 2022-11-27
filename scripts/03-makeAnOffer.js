const { ethers } = require("hardhat");

//address of the deployed manager contract
const ManagerAddress = "0x47a8c22a20d2e759eedb9ef27ca127c868756f73";

async function main() {
  const signers = await ethers.getSigners();
  const signer = signers[1];

  const ManagerContract = await ethers.getContractAt(
    "ManagerContract",
    ManagerAddress,
    signer
  );
  const tx = await ManagerContract.createGambleOffer({
    value: ethers.utils.parseEther("200"),
  });
  await tx.wait(1);
  const offercontractaddress = await ManagerContract.viewGambleContracts(0);
  console.log(offercontractaddress);

  const offerContract = await ethers.getContractAt(
    "GambleContract",
    offercontractaddress,
    signer
  );
  const offerMaker = await offerContract.viewOfferMaker();
  console.log(offerMaker);
  const offerAmount = await offerContract.viewOfferAmount();
  console.log(offerAmount);
}

main()
  .then(() => {
    process.exit(0);
  })
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });
