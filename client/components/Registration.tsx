import styles from "../styles/Registration.module.css";

function Registration() {
  return (
    <div>
      <h1 className={styles.h1}>Register Here!</h1>
      <div>
        <p className={styles.description}>
          Enter the Amount to Lock for your Kin:
        </p>
        <input className={styles.input} placeholder="Value in MATIC" />

        <p className={styles.description}>
          Enter the wallet Address of your Kin:
        </p>
        <input className={styles.input} placeholder="Enter Kin Address" />

        <button className={styles.button}>Register</button>
      </div>
    </div>
  );
}

export default Registration;
