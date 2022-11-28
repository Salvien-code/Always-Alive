import styles from "../styles/Blessing.module.css";

function Blessing() {
  return (
    <div>
      <p className={styles.description}>
        The protocol pays a random kin paid the earnings of last week {} to {}.
      </p>
    </div>
  );
}

export default Blessing;
