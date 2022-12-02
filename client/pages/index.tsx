import Head from "next/head";
import Image from "next/image";
import dynamic from "next/dynamic";
import styles from "../styles/Home.module.css";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import Link from "next/link";
import Blessing from "../components/Blessing";

export default function Home() {
  const DynamicMain = dynamic(() => import("../components/Main"), {
    ssr: false,
  });

  return (
    <div className={styles.container}>
      <Head>
        <title>Always Alive</title>
        <meta name="description" content="A decentralized Next of Kin dApp" />
        <link rel="icon" href="/AA_logo.png" />
      </Head>

      <header className={styles.header}>
        <Image
          height={250}
          width={250}
          src="/Always_Alive_Logo.svg"
          alt="Always Alive Logo"
        ></Image>{" "}
        <h1 className={styles.title}>Always Alive</h1>
        <ConnectButton />
      </header>
      <main className={styles.main}>
        <div id="interface">
          <p className={styles.description}>
            A Truly Decentralized Medium to send Funds to your Next of Kin.
          </p>
          <DynamicMain />
        </div>

        <p className={styles.description}>
          Check the{" "}
          <Link className={styles.link} href="/about" target="_blank">
            about
          </Link>{" "}
          page for more description
        </p>
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
