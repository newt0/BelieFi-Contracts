--[[
  BeliefFi DeFAI NFT - AO MAXI
  Atomic Assets AO Process Implementation
  MVP Version - Public Mint
  
  Technical Specifications:
  - NFT Name: AO MAXI
  - Strategy: Maximize $AO
  - Price: 1 USDA per NFT
  - Supply: 100 pieces maximum
  - Limit: 1 NFT per address
  - Mint Type: Public (no Allow List)
]]--

-- ============================================================================
-- IMPORTS & DEPENDENCIES
-- ============================================================================

local json = require("json")
local ao = require("ao")
local bint = require(".bint")(256)

-- ============================================================================
-- CONSTANTS & CONFIGURATION
-- ============================================================================

-- NFT Basic Information
local NFT_NAME = "AO MAXI"
local NFT_SYMBOL = "AOMAXI"
local NFT_DESCRIPTION = "DeFAI NFT Collection - Believe in AO's growth"
local NFT_STRATEGY = "Maximize $AO"
local NFT_DENOMINATION = "1"
local NFT_LOGO = "https://arweave.net/belieffi-logo-placeholder" -- TODO: Update with actual logo URL

-- Supply Configuration
local MAX_SUPPLY = 100
local MINT_LIMIT_PER_ADDRESS = 1
local MINT_PRICE = "1000000000000" -- 1 USDA (12 decimals)

-- Payment Token Configuration
local USDA_PROCESS_ID = "FBt9A5GA_KXMMSxA2DJ0xZbAq8sLLU2ak-YJe9zDvg8" -- AstroUSD Process ID

-- ============================================================================
-- GLOBAL STATE INITIALIZATION
-- ============================================================================

-- Initialize State if not exists
if not State then
  State = {}
end

-- NFT Minting State
State.total_minted = State.total_minted or 0
State.remaining_supply = State.remaining_supply or MAX_SUPPLY
State.mint_enabled = State.mint_enabled or true
State.public_mint_enabled = State.public_mint_enabled or true

-- Address Management
State.minted_by_address = State.minted_by_address or {} -- address -> boolean
State.nft_owners = State.nft_owners or {} -- nft_id -> owner_address
State.nft_balances = State.nft_balances or {} -- address -> count

-- NFT Metadata Storage
State.nft_metadata = State.nft_metadata or {} -- nft_id -> metadata
State.nft_ids = State.nft_ids or {} -- sequential list of minted NFT IDs

-- Fund Management (MVP - in-process management)
State.total_revenue = State.total_revenue or "0"
State.revenue_records = State.revenue_records or {} -- nft_id -> amount
State.process_balance = State.process_balance or "0"

-- Transaction Processing
State.processed_transactions = State.processed_transactions or {} -- tx_id -> boolean
State.pending_refunds = State.pending_refunds or {} -- address -> amount

-- Process Information
State.process_owner = State.process_owner or ao.id
State.created_at = State.created_at or os.time()

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Convert number to string with zero padding
local function padNumber(num, length)
  local str = tostring(num)
  while #str < length do
    str = "0" .. str
  end
  return str
end

-- Validate address format (basic check)
local function isValidAddress(address)
  if type(address) ~= "string" then
    return false
  end
  -- AO addresses are typically 43 characters
  if #address ~= 43 then
    return false
  end
  -- Check for valid Base64URL characters
  if not string.match(address, "^[A-Za-z0-9_-]+$") then
    return false
  end
  return true
end

-- Safe string to number conversion
local function safeToNumber(value)
  if type(value) == "number" then
    return value
  elseif type(value) == "string" then
    return tonumber(value) or 0
  else
    return 0
  end
end

-- Check if string is empty or nil
local function isEmptyString(str)
  return str == nil or str == ""
end

-- Get current timestamp in ISO8601 format
local function getCurrentTimestamp()
  return os.date("!%Y-%m-%dT%H:%M:%SZ")
end

-- Generate next NFT ID
local function generateNextNFTId()
  local nextId = State.total_minted + 1
  if nextId > MAX_SUPPLY then
    return nil
  end
  return nextId
end

-- Format NFT name with ID
local function formatNFTName(nftId)
  return NFT_NAME .. " #" .. padNumber(nftId, 3)
end

-- Calculate remaining mintable supply
local function getRemainingSupply()
  return MAX_SUPPLY - State.total_minted
end

-- Check if minting is still possible
local function isMintingActive()
  return State.mint_enabled and State.total_minted < MAX_SUPPLY
end

-- Check if address can mint (Public Mint)
local function canAddressMint(address)
  -- Basic validation
  if not isValidAddress(address) then
    return false, "Invalid address format"
  end
  
  -- Check if already minted
  if State.minted_by_address[address] then
    return false, "Address already minted"
  end
  
  -- Check supply limit
  if State.total_minted >= MAX_SUPPLY then
    return false, "All NFTs have been minted"
  end
  
  -- Public mint is enabled for everyone
  if not State.public_mint_enabled then
    return false, "Minting is currently disabled"
  end
  
  return true, "Eligible to mint"
end

-- Initialize balance for address if not exists
local function initializeBalance(address)
  if not State.nft_balances[address] then
    State.nft_balances[address] = 0
  end
end

-- Update NFT balance for address
local function updateBalance(address, delta)
  initializeBalance(address)
  State.nft_balances[address] = State.nft_balances[address] + delta
  
  -- Ensure non-negative balance
  if State.nft_balances[address] < 0 then
    State.nft_balances[address] = 0
  end
end

-- Get balance for address
local function getBalance(address)
  return State.nft_balances[address] or 0
end

-- Record minting for address
local function recordMinting(address, nftId)
  State.minted_by_address[address] = true
  State.nft_owners[nftId] = address
  updateBalance(address, 1)
  State.total_minted = State.total_minted + 1
  State.remaining_supply = getRemainingSupply()
  
  -- Add to NFT IDs list
  table.insert(State.nft_ids, nftId)
end

-- Log error (basic logging for MVP)
local function logError(message, context)
  print("[ERROR] " .. getCurrentTimestamp() .. " - " .. message)
  if context then
    print("[CONTEXT] " .. json.encode(context))
  end
end

-- Log info (basic logging for MVP)
local function logInfo(message)
  print("[INFO] " .. getCurrentTimestamp() .. " - " .. message)
end

-- Create error response
local function createErrorResponse(message)
  return {
    status = "error",
    message = message
  }
end

-- Create success response
local function createSuccessResponse(data)
  return {
    status = "success",
    data = data
  }
end

-- ============================================================================
-- PUBLIC MINT FUNCTIONS (Phase 1-2)
-- ============================================================================

-- Check if Public Mint is enabled
local function checkPublicMintEnabled()
  -- Public Mint is always enabled in MVP
  return State.public_mint_enabled
end

-- Validate mint request from address
local function validateMintRequest(address)
  -- Check if address format is valid
  if not isValidAddress(address) then
    return false, "Invalid address format"
  end
  
  -- Check if minting is globally enabled
  if not State.mint_enabled then
    return false, "Minting is currently disabled"
  end
  
  -- Check if Public Mint is enabled
  if not checkPublicMintEnabled() then
    return false, "Public mint is not enabled"
  end
  
  -- Check if address has already minted
  if State.minted_by_address[address] then
    return false, "Address has already minted the maximum allowed (1 NFT)"
  end
  
  -- Check supply availability
  if State.total_minted >= MAX_SUPPLY then
    return false, "All NFTs have been minted (100/100)"
  end
  
  return true, "Mint request is valid"
end

-- Check if an address can mint (simplified check)
local function canMint(address)
  local isValid, message = validateMintRequest(address)
  return isValid, message
end

-- Get mint status for an address
local function getMintStatus(address)
  local status = {
    total_supply = MAX_SUPPLY,
    current_supply = State.total_minted,
    remaining = getRemainingSupply(),
    mint_price = MINT_PRICE,
    mint_enabled = State.mint_enabled,
    public_mint_enabled = checkPublicMintEnabled()
  }
  
  if address and isValidAddress(address) then
    status.address = address
    status.has_minted = State.minted_by_address[address] or false
    status.can_mint, status.reason = canMint(address)
  end
  
  return status
end

-- Toggle minting (admin function - for emergency pause)
local function toggleMinting(enabled)
  State.mint_enabled = enabled
  logInfo("Minting " .. (enabled and "enabled" or "disabled"))
  return State.mint_enabled
end

-- Get public mint configuration
local function getPublicMintConfig()
  return {
    enabled = checkPublicMintEnabled(),
    max_per_address = MINT_LIMIT_PER_ADDRESS,
    total_supply = MAX_SUPPLY,
    minted = State.total_minted,
    available = getRemainingSupply(),
    price = MINT_PRICE,
    price_token = "USDA",
    status = State.mint_enabled and "active" or "paused"
  }
end

-- ============================================================================
-- INITIALIZATION
-- ============================================================================

-- Initialize process metadata
local function initializeProcess()
  logInfo("Initializing BeliefFi NFT Process")
  logInfo("NFT Name: " .. NFT_NAME)
  logInfo("Max Supply: " .. tostring(MAX_SUPPLY))
  logInfo("Mint Price: " .. MINT_PRICE .. " (1 USDA)")
  logInfo("Public Mint: Enabled")
  
  -- Set initial process tags
  ao.id = ao.id or "PROCESS_ID_PLACEHOLDER"
  
  return true
end

-- Run initialization on process start
if not State.initialized then
  initializeProcess()
  State.initialized = true
end

-- ============================================================================
-- EXPORT MODULE (for testing and external access)
-- ============================================================================

-- Module exports for testing purposes
BeliefFiNFT = {
  -- Constants
  NFT_NAME = NFT_NAME,
  NFT_SYMBOL = NFT_SYMBOL,
  MAX_SUPPLY = MAX_SUPPLY,
  MINT_PRICE = MINT_PRICE,
  
  -- Helper functions
  isValidAddress = isValidAddress,
  canAddressMint = canAddressMint,
  getRemainingSupply = getRemainingSupply,
  isMintingActive = isMintingActive,
  getBalance = getBalance,
  
  -- Public Mint functions (Phase 1-2)
  checkPublicMintEnabled = checkPublicMintEnabled,
  validateMintRequest = validateMintRequest,
  canMint = canMint,
  getMintStatus = getMintStatus,
  getPublicMintConfig = getPublicMintConfig,
  toggleMinting = toggleMinting,
  
  -- State access
  getState = function() return State end,
  getTotalMinted = function() return State.total_minted end,
  
  -- Utility functions
  padNumber = padNumber,
  formatNFTName = formatNFTName,
  generateNextNFTId = generateNextNFTId,
  getCurrentTimestamp = getCurrentTimestamp,
  recordMinting = recordMinting
}

-- ============================================================================
-- PROCESS READY
-- ============================================================================

logInfo("BeliefFi NFT Process initialized successfully")
logInfo("Ready to accept Public Mints")