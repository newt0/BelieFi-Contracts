Based on the deliverables from Phase 1-1, implement the Public Mint functionality.

Requirements:

- Basic implementation of Public Mint (no Allow List)
- Anyone can mint
- Simple validation logic
- Minimal functionality for MVP

Implementation Details:

1. Public Mint enable flag
2. Simple mint eligibility check function
3. Basic address format validation only

Data Structure:

- PUBLIC_MINT_ENABLED: true (always enabled)
- mint_enabled: global mint enable/disable flag

Functional Requirements:

1. checkPublicMintEnabled(): Confirm Public Mint is enabled
2. validateMintRequest(address): Basic validation of mint request
3. canMint(address): Check if address can mint

Constraints:

- Maximum 100 NFTs
- Only 1 mint per address
- No Allow List check

Error Handling:

- Handle invalid address format
- Handle mint disabled state

Please implement by adding to the previous code.
