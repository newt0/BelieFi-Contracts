# AI Agent Action List

## Scheduled Actions (Dexi cron triggers)

### 1. DCA (Dollar Cost Averaging) Execution

```lua
-- Basic action executed daily
function ExecuteDailyDCA()
  local daily_budget = GetDailyBudget()  -- 5 USDA ÷ 365 days
  local current_ao_price = GetCurrentPrice("AO", "USDA")
  -- Swap $USDA → $AO on Botega
  SwapOnBotega({
    from_token = "USDA",
    to_token = "AO",
    amount = daily_budget,
    slippage = 5.0
  })
  -- Record transaction
  RecordTransaction("DCA", daily_budget, current_ao_price)
end
```

### 2. Portfolio Rebalancing

```lua
-- Executed weekly or when balance threshold is reached
function RebalancePortfolio()
  local current_usda = GetBalance("USDA")
  local current_ao = GetBalance("AO")
  local total_value = current_usda + (current_ao * GetPrice("AO"))
  local target_usda_ratio = 10  -- Hold 10% USDA (for continued operations)
  local target_ao_ratio = 90    -- Hold 90% AO
  if NeedsRebalancing(current_ratio, target_ratio) then
    ExecuteRebalance(target_usda_ratio, target_ao_ratio)
  end
end
```

## Conditional Actions

### 3. Smart Swap (Price threshold trigger)

```lua
-- Execute only when price meets specific conditions
function CheckSmartSwapConditions()
  local current_price = GetCurrentPrice("AO", "USDA")
  local nft_metadata = GetNFTMetadata()
  local lucky_number = nft_metadata.lucky_number
  -- Individual threshold based on Lucky Number
  local buy_threshold = CalculateBuyThreshold(lucky_number)
  if current_price < buy_threshold then
    ExecuteLargeSwap({
      amount = GetAvailableBalance("USDA") * 0.5,
      reason = "Smart Swap - Price Below Threshold"
    })
  end
end
```

### 4. Market Sentiment Response

```lua
-- Additional purchases based on Apus Network market analysis
function CheckSentimentBasedAction()
  local sentiment = GetMarketSentiment()  -- Apus Network
  local confidence = sentiment.confidence_score
  if sentiment.ao_sentiment == "very_bullish" and confidence > 0.9 then
    ExecuteBoostPurchase({
      multiplier = 1.5,  -- 1.5x normal DCA
      reason = "High Confidence Bullish Signal"
    })
  end
end
```

## Information Gathering & Analysis Actions

### 5. Market Data Collection

```lua
-- Retrieve market information from Dexi
function CollectMarketData()
  local market_data = {
    ao_price = GetPriceFromDexi("AO"),
    volume_24h = GetVolumeFromDexi("AO"),
    liquidity_depth = GetLiquidityFromDexi("AO/USDA")
  }
  StoreMarketData(market_data)
  return market_data
end
```

### 6. Performance Tracking

```lua
-- Record agent performance
function TrackPerformance()
  local performance = {
    total_trades = GetTradeCount(),
    total_ao_accumulated = GetAOAccumulated(),
    average_purchase_price = GetAveragePrice(),
    days_active = GetDaysActive()
  }
  UpdatePerformanceMetrics(performance)
end
```

## Execution Schedule (Simplified)

| Action                 | Frequency   | Trigger                | Implementation Priority |
| ---------------------- | ----------- | ---------------------- | ----------------------- |
| DCA Execution          | Daily       | Dexi cron message      | ⭐ Highest              |
| Market Data Collection | Hourly      | Dexi cron message      | ⭐ High                 |
| Smart Swap Check       | Every 30min | Price change detection | 🔸 Medium               |
| Performance Tracking   | Daily       | After transaction      | 🔸 Medium               |
| Sentiment Response     | Hourly      | Sentiment change       | 🔹 Low                  |
| Rebalancing            | Weekly      | Portfolio ratio check  | 🔹 Low                  |
