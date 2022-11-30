import { useAccount } from "wagmi";
import styles from "../styles/Main.module.css";
import Registration from "./Registration";
import Validation from "./Validation";

function Main() {
  const { isConnected } = useAccount();

  return (
    <div>
      {isConnected ? (
        <div id="grid" className={styles.grid}>
          <div id="card" className={styles.card}>
            <Registration />
          </div>

          <div className={styles.card}>
            <Validation />
          </div>
        </div>
      ) : (
        <div>
          <h1 className={styles.title}>Please connect your wallet!</h1>
        </div>
      )}
    </div>
  );
}
export default Main;
