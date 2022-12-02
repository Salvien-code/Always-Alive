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
      <div>
        <h1 className={styles.h1}>Validation</h1>
        <p className={styles.description}>
          Your current Confirmations count: {readData as number}
        </p>
        <ul className={styles.ol}>
          <li className={styles.li}>
            Your confirmation count is incremented every 3 hours (UTC).
          </li>
          <li className={styles.li}>
            Your deposit funds will be inherited by your kin if confirmations
            exceeds 5.
          </li>
          <li className={styles.li}>
            The Protocol sends yield from AAVE to a random kin every 6 hours
            (UTC).
          </li>
          <li className={styles.li}>
            Hit the Validate Life Button to reset your confirmations to 0.
          </li>
        </ul>
      </div>
      <div className={styles.buttonArea}>
        <button
          disabled={!write}
          className={styles.button}
          onClick={() => write!()}
        >
          {!isLoading ? "Validate Life" : "Loading..."}
        </button>
      </div>
    </div>
  );
}

export default Validation;
