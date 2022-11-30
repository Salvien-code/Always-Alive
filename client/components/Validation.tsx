import { useState } from "react";
import {
  useAccount,
  useContractRead,
  usePrepareContractWrite,
  useContractWrite,
} from "wagmi";
import styles from "../styles/Validation.module.css";
import { ALWAYS_ALIVE_ABI, ALWAYS_ALIVE_ADDRESS } from "../utils/constants";

function Validation() {
  const { address } = useAccount();

  const { config } = usePrepareContractWrite({
    address: ALWAYS_ALIVE_ADDRESS,
    abi: ALWAYS_ALIVE_ABI,
    chainId: 80001,
    functionName: "validateLife",
  });

  const {
    data: writeData,
    isLoading,
    write,
  } = useContractWrite({
    ...config,
    onError(error) {
      window.alert(`Error: ${error}`);
    },
    onSuccess() {
      window.alert(`You have validated life!`);
    },
  });

  const { data: readData } = useContractRead({
    address: ALWAYS_ALIVE_ADDRESS,
    abi: ALWAYS_ALIVE_ABI,
    functionName: "getCurrentConfirmations",
    args: [address],
  });

  return (
    <div>
      <h1 className={styles.h1}>Validation</h1>
      <button
        disabled={!write}
        className={styles.button}
        onClick={() => write!()}
      >
        {!isLoading ? "Validate Life" : "Loading..."}
      </button>
      <p className={styles.description}>Reset your Confirmations to zero.</p>

      <p className={styles.description}>
        Your current Confirmations count: {readData as number}
      </p>
    </div>
  );
}

export default Validation;
