import { HardhatUserConfig } from "hardhat/config";
import { NetworkConfig } from "hardhat/types";
import "@nomicfoundation/hardhat-toolbox";
import "dotenv/config";

const { ALCHEMY_API_URL, METAMASK_PRIVATE_KEY, POLYGONSCAN_API_KEY } =
  process.env;

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.17",
      },
      {
        version: "0.8.10",
      },
    ],
  },
  defaultNetwork: "mumbai",
  networks: {
    mumbai: {
      url: ALCHEMY_API_URL,
      accounts: [METAMASK_PRIVATE_KEY!],
      allowUnlimitedContractSize: true,
    },
  },
  paths: {
    artifacts: "./client/contract-artifacts",
  },
  etherscan: {
    apiKey: POLYGONSCAN_API_KEY,
  },
};

export default config;
