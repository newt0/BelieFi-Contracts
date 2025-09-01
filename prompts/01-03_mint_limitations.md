Based on the deliverables from Phase 1-2, implement the Mint limitation management functionality.

Requirements:

- Strict implementation of 1 NFT per address limit
- Minted address tracking system
- Limit check functionality
- Pre-validation of mint eligibility

Implementation Details:

1. Recording and management system for minted addresses
2. Per-address mint limit check functionality
3. Available mint count calculation (maximum 100 pieces)
4. Error handling for limit violations

Data Structure:

- minted_by_address: Per-address mint records (boolean values)
- total_minted: Total mint count (0-100)
- remaining_mints: Remaining available mints (100-total_minted)

Functional Requirements:

1. checkMintEligibility(address): Mint eligibility determination
2. recordMint(address): Save mint records
3. getMintStatus(): Get mint status
4. validateMintRequest(address): Pre-validation of mint requests

Limit Logic (Public Mint version):

- **No Allow List check (anyone can mint)**
- Reject addresses that have already minted (1 per address maximum)
- Reject if supply cap of 100 pieces is reached
- Always exactly 1 NFT per mint transaction

Please add to the previous code and provide the complete integrated code.
