import Head from "next/head";
import Image from "next/image";
import Link from "next/link";

import styles from "../styles/Home.module.css";
import { ALWAYS_ALIVE_ADDRESS } from "../utils/constants";

export default function Home() {
  return (
    <div className={styles.container}>
      <Head>
        <title>Always Alive</title>
        <meta name="description" content="A decentralized Next of Kin dApp" />
        <link rel="icon" href="/AA_logo.png" />
      </Head>

      <header className={styles.header}>
        <h1 className={styles.title}>Always Alive</h1>
        <Image
          height={250}
          width={250}
          src="/Always_Alive_Logo.svg"
          alt="Always Alive Logo"
        ></Image>{" "}
      </header>

      <main>
        <h1>Project Details</h1>
        <p>
          A decentralized way to send funds to a next of kin without the need
          for a middleman.
        </p>
        <p>
          Here is the{" "}
          <Link
            href={`https://mumbai.polygonscan.com/address/${ALWAYS_ALIVE_ADDRESS}#code`}
            className={styles.link}
            target="_blank"
          >
            link
          </Link>{" "}
          to the verified Always Alive contract address on Polygon Mumbai
          Network:
        </p>

        <h1>Tech Stack</h1>
        <dl>
          <ol>
            <li>
              <dt>Chainlink VRF</dt>
              <dd>
                Chainlink provides the protocol with verifiable random numbers
                which are used to determine a random kin that wins 90% of the
                accrued yield from AAVE.
              </dd>
            </li>
            <li>
              <dt>Chainlink Automation</dt>
              <dd>
                Chainlink Automation handles smart contract automation on some
                functions:
                <ul>
                  <li>
                    incrementConfirmations: Increments the counter of all users
                    every 3 hours
                  </li>
                  <li>
                    bless: Transfers AAVE yield to random kin every 6 hours.
                  </li>
                  <li>
                    Inherit: Pays out deposited to kin when user
                    validationOfLife is false. Runs every 12 hours
                  </li>
                  <li>
                    Request Randomness: Interacts with the deployed VRFConsumer
                    contract to request random words. Called 3 hours before the
                    bless function.
                  </li>
                </ul>
              </dd>
            </li>
            <li>
              <dt>AAVE</dt>
              <dd>
                <p>
                  The Always Alive contract supplies all deposited funds to AAVE
                  to earn yield. 90% of the generated interest is sent to a
                  random kin every 6 hours.
                </p>
                <p>
                  <em>
                    The <b>AAVE Testnets</b> do not support withdraws so the
                    deposited inheritance is gone the moment it is deposited to
                    AAVE. So I improvised this by sending the inheritance from
                    the contract balance, I will also periodically send MATIC to
                    the contract so it always has liquidity.
                  </em>
                </p>
              </dd>
            </li>
            <li>
              <dt>Next.JS</dt>
              <dd>The Frontend is built using Next.JS</dd>
            </li>

            <li>
              <dt>Hardhat</dt>
              <dd>Used Hardhat to develop the solidity smart contracts.</dd>
            </li>

            <li>
              <dt>RainbowKit and Wagmi</dt>
              <dd>
                Helpful open-source projects for easily reading and writing to
                the blockchain, and also provided an easy-to-use Connect Button.
              </dd>
            </li>
          </ol>
        </dl>
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
