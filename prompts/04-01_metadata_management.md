Based on the Phase 3 deliverables, implement NFT metadata management functionality.

Requirements:

- Implementation of complete NFT metadata structure
- Dynamic metadata generation (lucky_number, market_sentiment integration)
- Metadata validation functionality
- Atomic Assets compliant data structure

Implementation Details:

1. Complete NFT metadata structure definition
2. Dynamic metadata generation functionality
3. Metadata verification and validation
4. Metadata retrieval and update functionality

Technical Specifications:
NFT Metadata Structure:
{
name: "AO MAXI #[001-100]",
description: "Believing in AO's growth",
strategy: "Maximize $AO",
image: "Fixed image URL",
external_url: "https://belieffi.arweave.net/nft/[nft_id]",
lucky_number: 0-999 numeric value,
market_sentiment: {
ao_sentiment: "bullish"|"bearish"|"neutral"|"very_bullish",
confidence_score: 0.0-1.0,
analysis_timestamp: ISO8601 string,
market_factors: string array,
sentiment_source: "Powered by Apus Network"
},
attributes: [
{trait_type: "Lucky Number", value: lucky_number},
{trait_type: "Market Sentiment", value: ao_sentiment},
{trait_type: "Confidence Score", value: confidence_score},
{trait_type: "Strategy", value: "AO MAXI"}
]
}

Data Structures:

- nft_metadata: Metadata storage by NFT ID
- metadata_templates: Metadata templates
- validation_rules: Validation rules

Functional Requirements:

1. generateNFTMetadata(nft_id, owner, lucky_number): Generate metadata
2. validateMetadata(metadata): Validate metadata
3. updateMetadata(nft_id, updates): Update metadata
4. getMetadata(nft_id): Retrieve metadata
5. formatNumberWithZeroPad(number, digits): Zero padding

Metadata Generation Logic:

1. Create base metadata
2. Integrate lucky_number
3. Integrate market_sentiment
4. Generate attributes array
5. Final validation

Validation Rules:

- Required field existence check
- Data type validation
- Value range validation
- Structural integrity check

Please add to the previous code and implement complete code including NFT metadata management.
