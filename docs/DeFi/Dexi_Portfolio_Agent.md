This agent operates according to customizable risk profiles defined by the user, dynamically adjusting strategies to maximize capital efficiency and yield potential. Users can spawn an unlimited number of Portfolio Agents each with unique configurations tailored to specific financial objectives.

### Functionalities:

- **Asset Management**: Automatically receives and strategically deploys funds across diverse asset classes.
- **Continuous Rebalancing**: Actively buys and sells assets to maintain portfolio balance according to predefined strategies.
- **Yield Optimization**: Identifies and allocates funds into high-yield opportunities such as Liquidity Provider (LP) Pools and Lending Markets.

### Portfolio Agent Lifecycle

The Portfolio Agent operates as a trustless autonomous process running on the AO Network, initiated on behalf of the creator/user.

The typical lifecycle of a Portfolio Agent includes:

- **Creation & Funding** → Agent is initialized and funded by the user.
- **Continuous Optimization** → Agent autonomously manages assets through rebalancing and yield generation.
- **Termination & Withdrawal** → User can terminate the agent at any time, withdrawing all managed funds.

## Creating and Managing a Portfolio Agent on Dexi

### Connecting Your Wallet & Navigating the Interface

First, connect your crypto wallet to Dexi. Once connected, navigate to the **My Portfolio** page. Here, you have a comprehensive overview of your portfolio:

- **Asset Overview**: Displays your held assets and their values.
- **Liquidity Pools (LPs)**: Lists active pools you're participating in.
- **Running Agents**: Shows all currently active autonomous agents you've spawned.
- **Transaction History**: Records all your past transactions.
- Other financial instruments on the AO network

Consider this your command center—a centralized dashboard providing full visibility and control over your interactions within the AO ecosystem.

### Spawning a Portfolio Agent

From the **My Portfolio** page, click on the clearly indicated **"Spawn Portfolio Agent"** button. This action will open a modal window allowing you to configure your new Portfolio Agent comprehensively.

#### Configuring Your Portfolio Agent

When the configuration modal opens, you will be asked for several key inputs:

- **Agent Name**: Give your agent a unique, easily identifiable name.
- **Quote Token**: Currently, AO is the default quote token used to value your portfolio. You can also use AR or other Assets as the Quote assets.
- **Portfolio Tokens**: Select at least two tokens to include in your agent's portfolio.

Once tokens are selected, Dexi automatically populates the available tokens list, clearly displaying:

- **Token Name**
- **Current Price**
- **Available Liquidity**

Initially, your portfolio allocation will be evenly distributed across selected tokens. Adjust individual allocations by changing percentages, instantly reflected visually in an interactive pie chart.

As you modify the token percentages:

- The pie chart dynamically updates, clearly illustrating your portfolio's composition.
- Each token's allocation can be precisely adjusted, providing granular control over your asset exposure.

#### Deviation Percentage Explained

The **Deviation Percentage** allows the Portfolio Agent to determine permissible fluctuations away from the target asset allocations during active management.

For example:

- A **10% deviation** means:

  - A portfolio with **4 assets** allows each asset to deviate by approximately **±2.5%**.
  - A portfolio with **10 assets** means each asset deviates roughly **±1%**.

This flexible mechanism helps minimize unnecessary trading costs while maintaining portfolio balance efficiently.

#### Slippage Tolerance

**Slippage Tolerance** defines the maximum acceptable price impact when your agent swaps tokens. This feature ensures your agent executes trades efficiently, balancing speed and cost-effectiveness.

- Dexi primarily supports Uniswap V2-type pools, meaning some price impact is inevitable.
- A **minimum of 5% slippage tolerance** is recommended, accommodating lower-liquidity pools effectively.
- When enabled, the agent always seeks the lowest possible price impact, ensuring optimal execution conditions for your portfolio.

#### Funding & Spawning Your Agent

After configuring your asset selections, deviation, slippage tolerance, and reviewing your portfolio allocation:

1.  Enter the total **Investment Amount** in AO Tokens.
2.  Click **"Create"** to spawn your Portfolio Agent.

Upon creation, your funds are deployed, and the Portfolio Agent becomes an autonomous, active process within the AO ecosystem.

### Managing Your Portfolio Agent

After deployment, Dexi provides intuitive controls to actively manage your Portfolio Agent directly through the user-friendly agent interface.

#### Top-up, Pause, and Withdraw Actions

Once your Portfolio Agent is active, you'll have convenient controls at your fingertips:

- **🔼 Top-up**

  - Allows you to add additional funds to an already running agent. Useful for scaling successful strategies or reacting proactively to market conditions.

- **⏸️ Pause**

  - Temporarily pauses your agent’s autonomous actions, halting all rebalancing and asset management activities. Ideal during volatile or uncertain market periods, letting you manually review conditions or strategies before resuming operations.

- **🔽 Withdraw**

  - Initiates the termination of your Portfolio Agent, prompting the withdrawal of all managed funds. A detailed summary screen appears, clearly displaying assets to withdraw, deposit history, and the agent’s lifetime performance metrics (PnL, duration, rebalance frequency).

#### Agent Withdrawal Summary

When withdrawing, Dexi provides a comprehensive summary:

- **Assets to Withdraw**: Clearly lists tokens and their current value.
- **Deposit History**: Displays the total funds you've deposited into the agent.
- **Performance Overview**: Summarizes the agent’s lifespan, number of rebalances, total deposited funds, and overall profit or loss, giving complete transparency on its effectiveness.

### Agent Interface Overview (Monitoring Your Agent)

Clicking your newly spawned Portfolio Agent opens its detailed interface, designed to offer a clear, actionable overview of your agent’s ongoing activities.

- Displays agent name, type, ownership, and current net worth.
- Quick-action buttons such as "Clone Agent" and immediate controls for process management.
- **Agent Status Bar**:

  - Shows real-time status (**Balanced**, **Rebalancing**, or **Idle**).
  - Indicates current maximum imbalance and last rebalance activity.
  - Clearly specifies the quote token and slippage settings.

- **Allocation Charts**:

  - Visually compares target vs. current asset allocations.
  - Enables quick visual confirmation of portfolio balance.

- **Historical Networth Chart**:

  - Provides a dynamic visualization of your portfolio's value over time.
  - Interactive and informative, making tracking performance intuitive.

- **Overview Section**:

  - Detailed breakdown of all tokens managed by your agent, including current holdings, token prices, paper values, and realizable values.

- **Rebalance History**:

  - Chronological record of past rebalance actions.
  - Clearly highlights changes in asset positions with color-coded performance indicators, giving full transparency to the agent's decisions.
