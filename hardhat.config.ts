import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "dotenv/config";

const { ALCHEMY_API_URL, METAMASK_PRIVATE_KEY, POLYGONSCAN_API_KEY } =
  process.env;

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  defaultNetwork: "mumbai",
  networks: {
    mumbai: { url: ALCHEMY_API_URL, accounts: [METAMASK_PRIVATE_KEY!] },
  },
  paths: {
    artifacts: "./client/artifacts",
  },
  etherscan: {
    apiKey: POLYGONSCAN_API_KEY,
  },
};

export default config;
