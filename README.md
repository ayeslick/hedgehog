# HedgeHog

Creates credit from assets by wrapping and then "splitting" the underlying asset into 1:1 tokens and an NFT of equivalent value.

## Overview
This protocol creates credit from assets by splitting the position into two tokens, an ERC20, and an NFT. The ERC20, CREDS, is the wrapped version of the position similar to wrapping ETH. The NFT, CREDIT, represents the position itself. The value of the asset determines the value of both CREDS and CREDIT. Ex. If a customer deposits an asset that's valued at $100 then they will receive 100 CREDS and an NFT that represents $100. Both CREDS and CREDIT are effectively 1:1 with the asset. The protocol also features a wrapper contract that enable customers to deposit underlying assets and the wrapper contracts deposit them into their respective yield generation protocols. Utilizing Tempus allows customers with fixed positions to have more capital efficiency. Customers are also able to obtain the underlying collateral they want without having to use multiple protocols which saves on time and gas.

## Features
Three contracts; Credits, Creds, and TokenManager, make up the core of the protocol. CREDS is a standard ERC-20 contract. CREDIT is a standard ERC-721 with a few modifications. TokenManager is a custom contract that owns both CREDS and CREDITS. It is the entry point for the system. Customers and contracts interface with the system through the TokenManager contract. Once a credit is created the current holder is able to add or subtract value from the credit. If they add more value by calling the respective function they will receive more CREDS and the value that the CREDIT represents increases. The inverse happens for subtracting value. Customers also have to have a corresponding amount of CREDS to burn. If a customer wants to claim the underlying collateral they have to have a CREDIT equal to the amount they want to claim and an equivalent amount of CREDS to burn.

### Tempus Integration
The Tempus-HedgeHog contract is a wrapper that receives a customers underlying collateral, deposit it into Tempus, receive and deposit the Tempus fixed income tokens into TokenManager then send the CREDS and CREDIT to the customer. 

## Acknowledgement
Foundry - Tooling

Element Finance - First introduction to the idea of splitting yield bearing assets into principal and yield tokens

Tempus Finance - Fixed Income Protocol used in first integration
