# HedgeHog

Creates Credit From Fixed Income Positions

## Overview
This protocol creats credit from fixed income postions by splitting the position into two tokens, an ERC20 and a NFT. The ERC20, CREDS, is the wrapped version of the position similar to wrapping ETH. The NFT, CREDIT, represents the position itself. The value of the position determines the value of both CREDS and CREDIT. Ex. If a customer deposits a fixed income postion thats valued at $100 then they will receive 100 CREDS and a NFT that represents $100. Both CREDS and CREDIT are effectively 1:1 with the fixed income postion. 

## Features
Three contracts; TempusCredits, TempusCreds and TokenManager, make up the core of the protocol. The HedgeHog contract, Tempus-HedgeHog, is effectively a wrapper thats used to receive a customers underlying collateral, deposit it into Tempus, receive and deposit the Tempus fixed income tokens into TokenManager then send the CREDS and CREDIT to the customer. 

## Acknowledgement
Foundry, Element Finance, Tempus Finance
