import styles from "../styles/Blessing.module.css";
import { ALWAYS_ALIVE_ABI, ALWAYS_ALIVE_ADDRESS } from "../utils/constants";
import { useContractRead } from "wagmi";

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

  return (
    <div>
      <p className={styles.description}>
        {/* The protocol gifted {lastPayout ? (lastPayout as number) : ""}, the
        accrued yield from AAVE to{" "}
        {lastBlessedKin ? (lastBlessedKin as string) : ""}. */}
      </p>
    </div>
  );
}

export default Blessing;
