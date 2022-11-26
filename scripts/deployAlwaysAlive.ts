import { ethers, run } from "hardhat";
import { setTimeout } from "timers/promises";

async function main() {
  const initialDeposit = ethers.utils.parseEther("0.01");

  const AlwayAliveFactory = await ethers.getContractFactory("AlwaysAlive");
  const alwaysAliveContract = await AlwayAliveFactory.deploy({
    value: initialDeposit,
  });
  await alwaysAliveContract.deployed();

  console.log(
    `Always Alive Contract deployed to ${alwaysAliveContract.address}\n`
  );

  console.log(`Waiting for a minute before verifying Consumer contract`);
  await setTimeout(60000);

  await run("verify:verify", {
    address: alwaysAliveContract.address,
  });
  console.log(`Verified AlwaysAlive contract on PolygonScan`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
