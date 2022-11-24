import { ethers, run } from "hardhat";

import { setTimeout } from "timers/promises";

async function main() {
  const AlwaysAlive = await ethers.getContractFactory("AlwaysAlive");
  const alwaysAlive = await AlwaysAlive.deploy();

  await alwaysAlive.deployed();

  console.log(`Contract deployed to ${alwaysAlive.address}\n`);

  console.log(`Waiting for a minute before verifying`);
  await setTimeout(60000);
  await run("verify:verify", {
    address: alwaysAlive.address,
  });
  console.log(`Verified contract on PolygonScan`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
