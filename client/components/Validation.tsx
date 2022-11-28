import styles from "../styles/Validation.module.css";

function Validation() {
  return (
    <div>
      <h1 className={styles.h1}>Validation</h1>
      <button className={styles.button}>Validate Life</button>
      <p className={styles.description}>Reset your Confirmations to zero.</p>

      <button className={styles.button}>Get Confirmations</button>
      <p className={styles.description}>Get your current Confirmations count</p>
    </div>
  );
}

export default Validation;
