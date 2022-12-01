import { ethers, run } from "hardhat";
import { setTimeout } from "timers/promises";

async function main() {
  const SignatureVerifierFactory = await ethers.getContractFactory(
    "SignatureVerifier"
  );
  const signatureVerifierContract = await SignatureVerifierFactory.deploy();
  await signatureVerifierContract.deployed();

  console.log(
    `Always Alive Contract deployed to ${signatureVerifierContract.address}\n`
  );

  console.log(`Waiting for a minute before verifying Consumer contract`);
  await setTimeout(60000);

  await run("verify:verify", {
    address: signatureVerifierContract.address,
  });
  console.log(`Verified Signature Verifier contract on PolygonScan`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
