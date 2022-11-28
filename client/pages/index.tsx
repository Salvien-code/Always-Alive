import Head from "next/head";
import Image from "next/image";
import styles from "../styles/Home.module.css";

import { ConnectButton } from "@rainbow-me/rainbowkit";
import Registration from "../components/Registration";
import Blessing from "../components/Blessing";
import Validation from "../components/Validation";

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
            <Registration />
          </div>

          <div className={styles.card}>
            <Validation />
          </div>
        </div>
        <Blessing />
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
