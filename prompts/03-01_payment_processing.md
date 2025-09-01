Based on the Phase 2 deliverables, implement a payment processing system.

Requirements:

- AstroUSD (USDA) payment processing (1 USDA fixed)
- Payment verification functionality
- Payment failure handling
- Token transfer reception and verification

Implementation Details:

1. Payment reception processing via Credit-Notice Handler
2. Payment amount verification (exactly 1 USDA = 1000000000000 units)
3. Payment source address verification
4. Handling of insufficient/excess payments

Technical Specifications:

- Payment token: AstroUSD (USDA)
- Token Process ID: "FBt9A5GA_KXMMSxA2DJ0xZbAq8sLLU2ak-YJe9zDvg8"
- Required amount: "1000000000000" (1 USDA)
- Excess payment: Refund processing
- Insufficient payment: Return error
- Timeout: No setting (indefinite waiting)

Data Structures:

- payment_records: Payment records
- processed_transactions: Processed Transaction IDs
- pending_refunds: Pending refund list

Handler Implementation:

1. Credit-Notice Handler: Process only when msg.From == USDA Token ID
2. Transaction ID duplicate check functionality
3. Payment amount verification (exactly 1000000000000)
4. Mint limit check (Public Mint support)
5. Excess amount refund functionality

Error Handling:

- Insufficient amount: "Insufficient payment. Required: 1 USDA"
- Excess amount: Refund difference + "Overpayment refunded"
- Already minted: "Address already minted"
- Sold out: "Sold out - 100 NFTs already minted"
- Duplicate processing: "Transaction already processed"

Rollback Processing:

- Level 1: After payment reception, error before Mint → Full refund

MVP Simplification:

- No Allow List check (Public Mint)
- Basic error handling only
- Simple refund processing

Please add to the previous code and implement complete code including payment processing.
