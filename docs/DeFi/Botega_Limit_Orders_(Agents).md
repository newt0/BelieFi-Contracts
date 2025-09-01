# Botega Limit Order

All advanced order types on Botega are actually powered by Autonomous Agents. These are independent processes created specifically for the user, designed to interact with various systems such as oracles, liquidity pools, and more. These agents carry advanced logic, enabling features like trailing stops, risk assessments, and other sophisticated trading strategies.

The Limit Order tab allows you to easily create a limit order on Botega. This feature lets you set the price at which you want to buy or sell, and the order will only execute when the market reaches your specified price.

### How to Use the Limit Order Feature on Botega

#### 1. Select Your Trading Tokens

- **Under "You Sell"**: Choose the token you want to sell by selecting it from the dropdown menu. Make sure you have enough balance to cover the trade.
- **Under "You Buy"**: Select the token you want to receive in return for your sale.

  Your current balance will be displayed in the interface for easy reference.

#### 2. Set the Limit Price

- **Set the Desired Price**: This is the price at which you want the trade to occur. Enter the price manually in the "Limit Price" field.
- **Use Price Adjustment Buttons**: You can also use the quick adjustment buttons (such as Market, -1%, -5%, -10%) to set the price relative to the current market value.
- The price will be expressed in the number of tokens you wish to receive for each unit of the token you're selling.

#### 3. Specify the Token Amount

- **Enter the Amount**: Input the number of tokens you wish to sell. You can manually type this in or use the quick percentage buttons like 25%, 50%, 75%, or MAX, which will automatically allocate portions of your total balance.

  The system will automatically calculate how many tokens you will receive based on your set limit price.

#### 4. Set Expiry Time (Optional)

- **Select Expiry Time**: Choose how long the limit order should remain active before expiring. You can select predefined timeframes such as 1 hour, 4 hours, 1 day, or 3 days.

  If the market doesn't reach your limit price by the expiration time, the order will be canceled automatically.

#### 5. Review Order Details

Before starting the **Limit Order Agent**, review the following key details:

- **Limit Price**: The specific price at which your trade will execute.
- **Expiry**: The time by which your limit order will either be executed or expire.
- **Fees**: The trading fee percentage (usually 0.25%) applied to your trade.
- **Network Cost**: Any additional blockchain transaction costs.

#### 6. Start Limit Order Agent

Once you’ve double-checked all your details, click the **Start Limit Order Agent** button. This will create an autonomous agent that continuously monitors the market price and executes the trade when your conditions are met.

#### Tips

- **Price Selection**: Be sure to set a limit price that aligns with your trading goals and market expectations.
- **Expiry Planning**: Choose an expiry timeframe that suits your strategy, ensuring that you don’t miss the ideal market conditions.
- **Balance Management**: Always ensure you have enough funds to cover the transaction and associated fees.

#### Important Notes

- The **Limit Order Agent** will remain active until either your limit price is reached, the order expires, or you manually cancel it.
- You can monitor the progress of your limit orders in the **Orders** section of the platform.
- Be sure to double-check all parameters before activating the agent to avoid unintended trades.
