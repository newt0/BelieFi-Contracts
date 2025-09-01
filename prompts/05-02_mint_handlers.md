Based on the Phase 5-1 deliverables, implement Mint-related Handler group.

Requirements:

- Mint execution Handler (Credit-Notice integration)
- Allow List verification Handler
- Transfer Handler (future SBT support)
- Mint status management Handler

Implementation Details:

1. Credit-Notice Handler: Payment reception and Mint execution
2. Allow-List Handler: Address permission status verification
3. Transfer Handler: NFT transfer processing (with restrictions)
4. Mint-Status Handler: Mint possibility verification

Handler Specifications:

### Credit-Notice Handler

Action: "Credit-Notice"
Trigger: When receiving transfer from USDA token
Processing Flow:

1. Sender verification (accept USDA only)
2. Payment amount verification (exactly 1000000000000)
3. Mint restriction check (Public Mint)
4. Complete Mint execution
5. Result notification

### Mint-Eligibility Handler

Action: "Mint-Eligibility"
Tags: Address = target address to check
Return Data:
{
address: target address,
already_minted: true|false,
mint_eligible: true|false,
reason: reason explanation
}

### Transfer Handler

Action: "Transfer"  
Tags: Recipient = transfer destination, NFT-ID = NFT identifier
Constraints: Restricted implementation for SBT compatibility
Return: Transfer result (success/failure/restriction reason)

### Mint-Status Handler

Action: "Mint-Status"
Tags: Address = target address (optional)
Return Data:
{
total_supply: 100,
current_supply: current issued count,
remaining: remaining mintable count,
mint_price: "1 USDA",
status: "active"|"sold_out",
address_eligible: eligibility when address specified
}

Functional Requirements:

1. Proper management of asynchronous processing
2. Transaction ID duplicate prevention
3. Atomicity guarantee (prevent partial execution)
4. Detailed logging

Credit-Notice Processing Details:

1. Verify msg.From == USDA Token ID
2. Confirm msg.Tags["Action"] == "Credit-Notice"
3. Get payer address (From-Process or Sender)
4. Call executeFullMint() (Public Mint)
5. Notify result to Sender

Error Handling:

- Invalid sender: Ignore without processing
- Insufficient/excess payment: Appropriate refund processing
- Mint failure: Full refund + error notification
- System error: Detailed logging + manual handling flag

Response Standardization:

- Success: {status: "success", data: result data}
- Failure: {status: "error", message: error details}

MVP Simplification:

- Replace Allow List Handler with Mint-Eligibility Handler
- No Allow List check for Public Mint
- Remove Smart Wallet related processing

Please integrate with the previous code and implement complete code including full Handler group.
