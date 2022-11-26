import { ethers, run } from "hardhat";
import { setTimeout } from "timers/promises";

async function main() {
  const subscriptionID = 2710;
  const VRFConsumerFactory = await ethers.getContractFactory("VRFConsumer");
  const VRFConsumerContract = await VRFConsumerFactory.deploy(subscriptionID);

  await VRFConsumerContract.deployed();
  console.log(
    `VRF Consumer Contract deployed to ${VRFConsumerContract.address}\n`
  );

  console.log(`Waiting for a minute before verifying Consumer contract`);
  await setTimeout(60000);

  await run("verify:verify", {
    address: VRFConsumerContract.address,
    constructorArguments: [subscriptionID],
  });
  console.log(`Verified Chainlink contract on PolygonScan`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
