Based on the Phase 5 deliverables, implement basic error handling system (MVP simplified version).

Requirements:

- Basic error processing functionality
- Simple error messages
- Minimum necessary rollback
- Basic logging

Implementation Details:

1. Basic error catching
2. Error message return
3. Simple rollback processing
4. Console log output

Error Classification (Simplified Version):

### Input Errors

- "Invalid address format"
- "Invalid payment amount"
- "Invalid NFT ID"

### Business Errors

- "Address already minted"
- "All NFTs sold out"
- "Insufficient payment"

### System Errors

- "Mint failed"
- "Refund failed"
- "System error"

Unified Error Response (Simplified Version):
{
status: "error",
message: error message
}

Functional Requirements:

1. handleError(error_message): Basic error processing
2. sendError(msg, error_message): Send error response
3. logError(error_message): Console log output

Rollback (Simplified Version):

- Payment failure: Full refund
- Mint failure: State reset + refund

MVP Simplification Points:

- No complex error classification
- No detailed logging system
- No automatic retry
- No manual handling queue

Please integrate with the previous code and implement complete code including basic error handling.
