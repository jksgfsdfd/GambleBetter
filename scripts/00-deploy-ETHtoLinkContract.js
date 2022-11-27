const { ethers } = require("hardhat");

async function main() {
  const signers = await ethers.getSigners();
  const signer = signers[1];

  const ETHtoLINKFactory = await ethers.getContractFactory("ETHtoLink", signer);

  const Contract = await ETHtoLINKFactory.deploy();
  await Contract.deployed();
}

main()
  .then(() => {
    process.exit(0);
  })
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });
