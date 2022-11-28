import { useState } from "react";
import { useAccount, useContractRead } from "wagmi";
import styles from "../styles/Validation.module.css";
import { ALWAYS_ALIVE_ABI, ALWAYS_ALIVE_ADDRESS } from "../utils/constants";

function Validation() {
  const { address } = useAccount();

  const { data, isError, isLoading } = useContractRead({
    address: ALWAYS_ALIVE_ADDRESS,
    abi: ALWAYS_ALIVE_ABI,
    functionName: "getCurrentConfirmations",
    args: [address],
  });

  return (
    <div>
      <h1 className={styles.h1}>Validation</h1>
      <button className={styles.button}>Validate Life</button>
      <p className={styles.description}>Reset your Confirmations to zero.</p>

      <p className={styles.description}>
        Your current Confirmations count: {data as number}
      </p>
    </div>
  );
}

export default Validation;
