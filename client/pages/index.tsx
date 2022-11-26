import Head from "next/head";
import Image from "next/image";
import styles from "../styles/Home.module.css";

import { ConnectButton } from "@rainbow-me/rainbowkit";

export default function Home() {
  return (
    <div className={styles.container}>
      <Head>
        <title>Always Alive</title>
        <meta name="description" content="A decentralized Next of Kin dApp" />
        <link rel="icon" href="/AA_logo.png" />
      </Head>

      <header className={styles.header}>
        <Image
          height={300}
          width={300}
          src="/Always_Alive_Logo.svg"
          alt="Always Alive Logo"
        ></Image>{" "}
        <h1 className={styles.title}>Always Alive</h1>
        <ConnectButton />
      </header>
      <main className={styles.main}>
        <p className={styles.description}>
          A Truly Decentralized Medium to send Funds to your Next of Kin.
        </p>

        <div className={styles.grid}>
          <div className={styles.card}>
            <h2>Register &rarr;</h2>
            <p>Find in-depth information about Next.js features and API.</p>
          </div>

          <div className={styles.card}>
            <h2>Validate Life &rarr;</h2>
            <p>Hit the validate button before your Confirmations hit 5!</p>

            <h2>Get Current Confirmations</h2>
            <p>
              You&apos;re currently at {} Confirmations, click ValidateLife to
              take it back to zero!
            </p>
          </div>
          <div className={styles.card}>
            <h2>Blessed Kin</h2>
            <p>
              The protocol paid the earnings of last week {} to {}.
            </p>
          </div>
        </div>
      </main>

      <footer className={styles.footer}>
        <a
          href="https://simon-samuel.netlify.app/"
          target="_blank"
          rel="noopener noreferrer"
        >
          Made with &#9829; by Simon Samuel
        </a>
      </footer>
    </div>
  );
}
