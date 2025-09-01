Based on the Phase 3-1 deliverables, implement fund management functionality (MVP simplified version).

Requirements:

- No Smart Wallet creation (MVP simplification)
- Fund management within the process
- Recording and managing Mint revenue
- Simple balance management

Implementation Details:

1. Fund storage within the process
2. Recording Mint revenue
3. Balance management functionality
4. Refund processing implementation

Technical Specifications:

- Fund storage: Temporarily managed within the process
- Revenue recording: Record per Mint
- Refund: Direct transfer processing

Processing Flow:

1. Confirm Mint success
2. Update revenue records
3. Update process internal balance
4. Success notification

Data Structures:

- total_revenue: Total revenue amount
- revenue_records: Revenue records per Mint
- process_balance: Process internal balance

Functional Requirements:

1. recordRevenue(nft_id, amount): Record revenue
2. getProcessBalance(): Get balance
3. processRefund(address, amount): Process refund
4. getRevenueReport(): Revenue report

MVP Simplification Points:

- Remove Smart Wallet creation process
- No aos.spawn() required
- No complex fund transfer logic
- Manage all funds within the process

Error Handling:

- Refund failure: "Refund failed"
- Insufficient balance: "Insufficient balance"

Please integrate with the previous code and implement complete code including simplified fund management.
