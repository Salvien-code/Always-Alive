import { ethers, run } from "hardhat";
import { setTimeout } from "timers/promises";

async function main() {
  const YieldAggregatorFactory = await ethers.getContractFactory(
    "YieldAggregator"
  );
  const YieldAggregatorContract = await YieldAggregatorFactory.deploy();

  await YieldAggregatorContract.deployed();

  console.log(
    `AAVE Yield Aggregator Contract deployed to ${YieldAggregatorContract.address}\n`
  );

  console.log(`Waiting for a minute before verifying the Yield contract`);
  await setTimeout(60000);

  await run("verify:verify", {
    address: YieldAggregatorContract.address,
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
