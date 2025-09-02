Based on the Phase 4 deliverables, implement basic Handler group.

Requirements:

- Atomic Assets standard compliant Handler implementation
- Process information retrieval functionality
- Balance and metadata retrieval functionality
- Unified error handling

Implementation Details:

1. Info Handler: Return basic process information
2. Balance Handler: Check balance by address
3. Balances Handler: List all address balances
4. Metadata Handler: Return NFT metadata

Handler Specifications:

### Info Handler

Action: "Info"
Return Data:
{
Name: "AO MAXI",
Ticker: "AOMAXI",
Denomination: "1",
Logo: "Fixed logo URL",
Description: "DeFAI NFT Collection - Believing in AO's growth",
Total_Supply: "100",
Current_Supply: Current issued count,
Mint_Price: "1 USDA",
Mint_Status: "active"|"sold_out",
Mint_Type: "Public Mint",
Contract_Type: "Atomic Asset - BelieFi NFT"
}

### Balance Handler

Action: "Balance"
Tags: Target = target address
Return: NFT holdings count for the address

### Balances Handler

Action: "Balances"
Return: Balance map for all addresses

### Metadata Handler

Action: "Metadata"
Tags: NFT-ID = NFT identifier
Return: Complete metadata for specified NFT

Functional Requirements:

1. Standardized response format
2. Appropriate error messages on failure
3. Handling of non-existent data
4. Performance optimization

Error Responses:

- NFT not found: "NFT not found"
- Invalid address: "Invalid address format"
- Data retrieval failure: "Failed to retrieve data"

Please add to the previous code and implement complete code including basic Handler group.
