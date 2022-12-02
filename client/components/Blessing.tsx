import styles from "../styles/Blessing.module.css";
import { ALWAYS_ALIVE_ABI, ALWAYS_ALIVE_ADDRESS } from "../utils/constants";
import { useContractRead } from "wagmi";
import { BigNumber, ethers } from "ethers";

function Blessing() {
  const { data: lastBlessedKin } = useContractRead({
    address: ALWAYS_ALIVE_ADDRESS,
    abi: ALWAYS_ALIVE_ABI,
    functionName: "getLastBlessedKin",
  });
  const { data: lastPayout } = useContractRead({
    address: ALWAYS_ALIVE_ADDRESS,
    abi: ALWAYS_ALIVE_ABI,
    functionName: "getLastPayout",
  });

  let parsedPayout = ethers.utils.formatEther(lastPayout as BigNumber);

  return (
    <div>
      <p className={styles.description}>
        The protocol last gifted {lastBlessedKin as string} with {parsedPayout}{" "}
        MATIC.
      </p>
    </div>
  );
}

export default Blessing;
