import { ethers } from "ethers";
import { useState } from "react";
import {
  usePrepareContractWrite,
  useContractWrite,
  useSignMessage,
} from "wagmi";
import styles from "../styles/Registration.module.css";
import {
  ALWAYS_ALIVE_ABI,
  ALWAYS_ALIVE_ADDRESS,
  REGISTRATION_MESSAGE,
} from "../utils/constants";

function Registration() {
  const [amount, setAmount] = useState<string>("0.001");
  const [kinAddress, setKinAddress] = useState<string>();
  const [signature, setSignature] = useState<string>();

  let { isLoading: isSignLoading, signMessage } = useSignMessage({
    message: REGISTRATION_MESSAGE,
    onError(error) {
      window.alert(`Error: Something went wrong!`);
      console.error(error);
      isSignLoading = false;
    },
    onSuccess(data) {
      window.alert(`Signed successfully.`);
      setSignature(data);
    },
  });

  const { config } = usePrepareContractWrite({
    address: ALWAYS_ALIVE_ADDRESS,
    abi: ALWAYS_ALIVE_ABI,
    chainId: 80001,
    enabled: Boolean(amount) && Boolean(kinAddress) && Boolean(signature),
    functionName: "register",
    args: [kinAddress, signature],
    overrides: {
      value: ethers.utils.parseEther(amount),
    },
  });

  let { isLoading: isWriteLoading, write } = useContractWrite({
    ...config,
    onError(error) {
      window.alert(`Error: Something went wrong!`);
      console.error(error);
      isWriteLoading = false;
    },
    onSuccess() {
      window.alert(`Registering...`);
    },
  });

  return (
    <div>
      <div>
        <h1 className={styles.h1}>Register Here!</h1>
        <ol className={styles.ol}>
          <li className={styles.li}>
            Enter the Deposit Amount (Min 0.001 MATIC, Max 1 MATIC)
          </li>
          <li className={styles.li}>Enter your Kin&apos;s Mumbai Address</li>
          <li className={styles.li}>Sign the Registration Message</li>
          <li className={styles.li}>Hit the Register button</li>
        </ol>

        <form>
          <label className={styles.label}>Enter Amount (MATIC):</label>
          <input
            className={styles.input}
            type="number"
            step="0.001"
            onChange={(event) => {
              event.target.value
                ? setAmount(event.target.value)
                : setAmount("0.001");
            }}
            value={amount}
          />
          <label className={styles.label}>Enter Kin Address:</label>
          <input
            className={styles.input}
            type="text"
            onChange={(event) => setKinAddress(event.target.value)}
            value={kinAddress}
          />
        </form>

        <div className={styles.buttons}>
          <div>
            <button
              className={styles.button}
              disabled={isSignLoading}
              onClick={() => signMessage()}
            >
              {!isSignLoading ? "Sign" : "Loading..."}
            </button>
          </div>
          <button
            disabled={!write && isWriteLoading}
            className={styles.button}
            onClick={() => write?.()}
          >
            {!isWriteLoading ? "Register" : "Loading..."}
          </button>
        </div>
      </div>
    </div>
  );
}

export default Registration;
