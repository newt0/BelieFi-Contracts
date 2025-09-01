# BeliefFi Implementation Prompt List (MVP Version)

## Overview

This directory contains prompts for implementing BeliefFi DeFAI NFT project's Atomic Assets AO Process in phases. This is a simplified MVP implementation for hackathons using Public Mint approach.

## Technical Specifications

- Platform: AO (Arweave L2)
- NFT Standard: Atomic Assets
- Payment Currency: AstroUSD (USDA) - 1 USDA/NFT
- Supply Limit: 100 pieces
- Restriction: 1 NFT per address
- **Mint Method: Public Mint (No Allow List)**

## MVP Simplification Points

- ✅ Public Mint approach (anyone can mint)
- ✅ No Smart Wallet creation (funds managed within process)
- ✅ Basic error handling only
- ✅ Simple operational verification (no automated tests)

## Prompt Execution Order

### Phase 1: Foundation Implementation

| File                        | Dependencies | Description                              |
| --------------------------- | ------------ | ---------------------------------------- |
| `01-01_basic_structure.md`  | None         | AO Process basic structure, State init   |
| `01-02_public_mint.md`      | 01-01        | Public Mint basic functionality          |
| `01-03_mint_limitations.md` | 01-02        | 1 address 1 NFT limit, supply management |

### Phase 2: External Integration Implementation

| File                        | Dependencies | Description                             |
| --------------------------- | ------------ | --------------------------------------- |
| `02-01_lucky_number.md`     | 01-03        | Lucky Number generation (hardcoded)     |
| `02-02_market_sentiment.md` | 02-01        | Market Sentiment generation (hardcoded) |

### Phase 3: Payment & Fund Management

| File                          | Dependencies | Description                          |
| ----------------------------- | ------------ | ------------------------------------ |
| `03-01_payment_processing.md` | 02-02        | USDA payment processing & validation |
| `03-02_fund_management.md`    | 03-01        | In-process fund management           |

### Phase 4: NFT Core Functionality

| File                           | Dependencies | Description                                      |
| ------------------------------ | ------------ | ------------------------------------------------ |
| `04-01_metadata_management.md` | 03-02        | NFT metadata generation & management             |
| `04-02_mint_execution.md`      | 04-01        | Complete Mint execution, Atomic Assets compliant |

### Phase 5: Handler Implementation

| File                      | Dependencies | Description                                        |
| ------------------------- | ------------ | -------------------------------------------------- |
| `05-01_basic_handlers.md` | 04-02        | Info, Balance, Metadata Handlers                   |
| `05-02_mint_handlers.md`  | 05-01        | Credit-Notice, Mint-Eligibility, Transfer Handlers |

### Phase 6: Error Handling & Operational Verification

| File                            | Dependencies | Description                             |
| ------------------------------- | ------------ | --------------------------------------- |
| `06-01_basic_error_handling.md` | 05-02        | Basic error processing                  |
| `07-01_simple_test.md`          | 06-01        | Simple operational verification & debug |

## Execution Method

1. Execute each phase in order (maintain dependencies)
2. Pass deliverables from previous task to next task
3. Each prompt can be executed independently
4. If error occurs, re-execute from previous phase

## Final Deliverable

- Public Mint approach Atomic Assets AO Process
- Anyone can mint (1 NFT per address restriction)
- USDA payment & in-process fund management
- Basic error handling
- MVP quality ready for operation

## Notes

- RandAO & Apus Network integration planned for later (currently hardcoded)
- Smart Wallet functionality planned for post-MVP
- Bot protection to be added as needed later
- NFTs planned to be implemented as SBT (transfer-restricted) in the future
