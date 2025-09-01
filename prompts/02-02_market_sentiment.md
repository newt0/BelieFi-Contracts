Based on the Phase 2-1 deliverables, implement Market Sentiment generation functionality with hardcoded data.

Requirements:

- Fixed market_sentiment data generation
- Integration with NFT metadata
- Preparation for future Apus Network integration replacement
- Sufficient quality for demo purposes

Implementation Details:

1. Create predefined sentiment patterns
2. Selection based on Mint order or lucky_number
3. Generate market_sentiment object

Hardcode Specification:
sentiment_patterns = {
{ao_sentiment = "bullish", confidence_score = 0.85, market_factors = {"institutional_adoption", "developer_activity"}},
{ao_sentiment = "very_bullish", confidence_score = 0.92, market_factors = {"ecosystem_growth", "token_utility"}},
{ao_sentiment = "neutral", confidence_score = 0.65, market_factors = {"market_uncertainty"}},
{ao_sentiment = "bearish", confidence_score = 0.73, market_factors = {"regulatory_concerns"}},
...
}

Data Structure:
market_sentiment = {
ao_sentiment: string,
confidence_score: number,
analysis_timestamp: current time,
market_factors: array,
sentiment_source: "Powered by Apus Network"
}

Selection Logic:

- Selection based on lucky_number value range
- 0-199: "bearish"
- 200-399: "neutral"
- 400-699: "bullish"
- 700-999: "very_bullish"

Functional Requirements:

1. initializeSentimentPatterns(): Initialize sentiment patterns
2. getSentimentByLuckyNumber(lucky_number): Selection based on lucky_number
3. generateMarketSentiment(lucky_number): Generate sentiment
4. formatSentimentData(): Format data

Comments:
-- TODO: Replace this section when integrating with Apus Network in the future
-- Using hardcoded data

Please integrate with the previous code and implement complete code that includes market_sentiment generation.
