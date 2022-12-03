# Always Alive

<img align="center" src="https://github.com/Salvien-code/Heavy/blob/main/Always%20Alive%20Banner.png">

A decentralized and secure way to leave an inheritance for a next of kin without the need for a middleman.

# Tech Stack

- Chainlink VRF
- Chainlink Automation (Job Scheduler)
- AAVE
- Next.JS
- Hardhat
- RainbowKit and Wagmi

# Product use

This project solves the real-world issue of **Inheritance**, where a relative may be cheated out of the inheritance left behind for them. It eliminates the need for a legal entity as the contract sends the deposit to the kin's address thereby guaranteeing the user that ONLY the kin can receive the inheritance if the user should become deceased.

# Brief description

The Always Alive contract is currently deployed to the Polygon Mumbai network at this address: [0x3cd4E28CA85eEc549EdF514b423073Bd2c3dad1A](https://mumbai.polygonscan.com/address/0x3cd4E28CA85eEc549EdF514b423073Bd2c3dad1A#code)

The contract has 3 core logic:

## Registration

The minimum and maximum amount for registration are 0.001 and 1 MATIC respectively. Users have to supply their **Next of Kin address** and a valid **signature**. The deposited registration amount is sent to AAVE upon registration for yield farming.

## Blessing

This is the added benefit of using the protocol, it sends 90% of the accrued interest on AAVE to a random kin every 6 hours. The random kin is gotten using a **Verifiable Random Number** from Chainlink VRF and Chainlink Automation is in charge of calling this function every 6 hours in UTC.

## Inheritance

Users have to validate life before their confirmation counts exceed 5, the protocol transfers all the deposited amount to the next of kin address when this happens. The user's counts are incremented every 3 hours by Chainlink Automation but **Validating life** resets the user's confirmation counts to 0

    The AAVE Testnets currently do not support withdraws so the deposited amount sent to AAVE during registration is gone. So I improvised this by sending the inheritance from the contract balance, I will also periodically send MATIC to the contract so it always has liquidity for paying Kins. This is the reason for the maximum deposit amount.

# Developer's Final Words

This project currently uses 3 hours as the increment interval but an ideal real-world instance would be in months or weeks and this interval would be preset by the user during registration. Also, only MATIC is allowed as deposits but in reality, even NFTs that legally signify ownership of property could be deposited to the protocol.

Then regarding the name, **Always Alive**... the user technically sends funds to his kin when he's passed on but this means the user is "actually" alive. Using **Actually Alive** as the project name is a terrible idea... which is why I opted for the next less terrible name. :-)

Made with 🤍 by Simon Samuel.
