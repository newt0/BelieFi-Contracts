## Welcome to Botega

Botega is a decentralized finance (DeFi) platform built on autonomous agents, facilitating the exchange of assets across various models within the AO ecosystem. It supports Uniswap V2 and V3 automated market maker (AMM) models, as well as a global on-chain order book. Additionally, Botega offers market making via autonomous agent systems, which are capable of executing advanced order types and intelligently allocating liquidity without human intervention.

Botega versatility is made possible through AO's modular network design and horizontal scaling capabilities. This enables Botega to provide extremely low-latency transaction processing and highly programmable liquidity utilization.

### How is Botega Different?

#### Autonomous Market Makers

Compared to Uniswap's smart-contract AMMs, which are limited in performance by Ethereum's globally synchronized state, AMMs on Botega operate as independent processes within the AO network.

You can think of each liquidity pool as an individual rollup, maintaining its own localized state and access to network resources. This modular design enables Botega liquidity pools to scale independently, execute an unlimited number of transactions in parallel, and perform advanced on-chain data processing as autonomous agents.

#### Advanced Market Making Features

Botega technical architecture is not limited to AMMs. Botega is capable of providing various market making models such as orderbooks. Notably, since Botega processes can scale, replicate, and access unbounded network compute, they are capable of providing advanced market making features that would typically require offchain processing, commonly found on centralized exchanges. This includes:

- High-throughput and low latency swaps
- Send/receive message requests from pools, smart contracts, users, and agents
- Integrate AI models into transaction execution logic
- Autonomous execution of advanced order types

Botega is fully decentralized and permissionless. The frontend is simply client code deployed to the permanent storage on Arweave, while the execution logic is handled by AO processes. It is uncensorable and can always be accessed via the ARNS: "botega" on any Arweave gateway. For example, you can visit it at [https://botega.defi.ao](https://botega.defi.ao/).
