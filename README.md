# HedgeHog

Creates Credit From Fixed Income Positions

## Overview
This protocol creates credit from assets by splitting the position into two tokens, an ERC20, and an NFT. The ERC20, CREDS, is the wrapped version of the position similar to wrapping ETH. The NFT, CREDIT, represents the position itself. The value of the asset determines the value of both CREDS and CREDIT. Ex. If a customer deposits a fixed income position that's valued at $100 then they will receive 100 CREDS and an NFT that represents $100. Both CREDS and CREDIT are effectively 1:1 with the asset.

## Features
Three contracts; Credits, Creds and TokenManager, make up the core of the protocol. CREDS is a standard ERC-20 contract. CREDIT is a standard ERC-721 with a few modifications. TokenManager is a custom contract that owns both CREDS and CREDITS. It is the entry point for the system. 

### Tempus
The Tempus-HedgeHog is a wrapper that receives a customers underlying collateral, deposit it into Tempus, receive and deposit the Tempus fixed income tokens into TokenManager then send the CREDS and CREDIT to the customer. 

## Acknowledgement
Foundry, Element Finance, Tempus Finance
