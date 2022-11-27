const { ethers } = require("hardhat");

async function main() {
  const signers = await ethers.getSigners();
  const signer = signers[1];

  const ManagerFactory = await ethers.getContractFactory(
    "ManagerContract",
    signer
  );

  const ManagerContract = await ManagerFactory.deploy();
  await ManagerContract.deployed();
}

main()
  .then(() => {
    process.exit(0);
  })
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });
