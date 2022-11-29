import { ethers } from "ethers";
import dynamic from "next/dynamic";
import { useState } from "react";
import { usePrepareContractWrite, useContractWrite, useAccount } from "wagmi";
import styles from "../styles/Registration.module.css";
import { ALWAYS_ALIVE_ABI, ALWAYS_ALIVE_ADDRESS } from "../utils/constants";

function Registration() {
  const [amount, setAmount] = useState<string>();
  const [kinAddress, setKinAddress] = useState<string>();

  const { config } = usePrepareContractWrite({
    address: ALWAYS_ALIVE_ADDRESS,
    abi: ALWAYS_ALIVE_ABI,
    chainId: 80001,
    enabled: Boolean(amount) && Boolean(kinAddress),
    functionName: "register",
    args: [kinAddress],
    overrides: {
      value:
        typeof amount == "undefined"
          ? ethers.BigNumber.from("0")
          : ethers.utils.parseEther(amount),
    },
  });

  const { data, isLoading, write } = useContractWrite({
    ...config,
    onError(error) {
      window.alert(`Error: ${error}`);
    },
    onSuccess(data) {
      window.alert(`Registered successfully ${data}`);
    },
  });

  return (
    <div>
      <div>
        <h1 className={styles.h1}>Register Here!</h1>
        <p className={styles.description}>
          Enter the Amount to Lock for your Kin. Minimum is 0.001 MATIC.
        </p>
        <form>
          <label>
            Enter Amount:
            <input
              className={styles.input}
              type="number"
              step="0.001"
              onChange={(event) => setAmount(event.target.value)}
              value={amount}
            />
          </label>
          <label>
            Enter Kin Address:
            <input
              className={styles.input}
              type="text"
              onChange={(event) => setKinAddress(event.target.value)}
              value={kinAddress}
            />
          </label>
        </form>

        <button
          disabled={!write}
          className={styles.button}
          onClick={() => write!()}
        >
          {!isLoading ? "Register" : "Loading..."}
        </button>
      </div>
    </div>
  );
}

export default Registration;
