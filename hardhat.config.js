/** @type import('hardhat/config').HardhatUserConfig */
require("@nomiclabs/hardhat-ethers");
require("dotenv").config();

const GOERLI_URL = process.env.ALCHEMY_GOERLI_URL;
const GOERLI_ACCOUNT_1 = process.env.GOERLI_ACCOUNT1_PRIVATE_KEY;
const FREE_ACCOUNT_1 = process.env.FREE_ACCOUNT_1;
const FREE_ACCOUNT_2 = process.env.FREE_ACCOUNT_2;

module.exports = {
  solidity: "0.8.8",
  networks: {
    hardhat: {
      chainId: 5,
      forking: {
        url: GOERLI_URL,
        blockNumber: 7808200,
      },
    },
    localhost: {
      chainId: 5,
      url: "http://127.0.0.1:8545/",
      accounts: [GOERLI_ACCOUNT_1, FREE_ACCOUNT_1, FREE_ACCOUNT_2],
    },
  },
};
