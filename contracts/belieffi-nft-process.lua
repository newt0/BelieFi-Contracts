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
-- LUCKY NUMBERS CONFIGURATION (Phase 2-1)
-- ============================================================================

-- TODO: Replace with RandAO integration in the future
-- Hardcoded lucky numbers for MVP (100 values, range 0-999)
local LUCKY_NUMBERS = {
  42, 777, 123, 888, 256, 369, 555, 999, 111, 666,
  234, 789, 456, 321, 654, 87, 912, 345, 678, 210,
  543, 876, 159, 482, 715, 38, 961, 294, 527, 860,
  183, 416, 749, 82, 315, 648, 981, 214, 547, 880,
  113, 446, 779, 12, 345, 678, 911, 244, 577, 810,
  143, 476, 709, 42, 375, 608, 941, 274, 507, 840,
  173, 406, 739, 72, 305, 638, 971, 204, 537, 870,
  103, 436, 769, 2, 335, 668, 901, 234, 567, 800,
  133, 466, 799, 32, 365, 698, 931, 264, 597, 830,
  163, 496, 729, 62, 395, 628, 961, 294, 527, 860
}

-- ============================================================================
-- MARKET SENTIMENT CONFIGURATION (Phase 2-2)
-- ============================================================================

-- TODO: Replace with Apus Network integration in the future
-- Hardcoded market sentiment patterns for MVP
local SENTIMENT_PATTERNS = {
  bearish = {
    ao_sentiment = "bearish",
    confidence_score = 0.73,
    market_factors = {"regulatory_concerns", "market_volatility", "institutional_uncertainty"}
  },
  neutral = {
    ao_sentiment = "neutral",
    confidence_score = 0.65,
    market_factors = {"market_uncertainty", "mixed_signals", "consolidation_phase"}
  },
  bullish = {
    ao_sentiment = "bullish",
    confidence_score = 0.85,
    market_factors = {"institutional_adoption", "developer_activity", "ecosystem_expansion"}
  },
  very_bullish = {
    ao_sentiment = "very_bullish",
    confidence_score = 0.92,
    market_factors = {"ecosystem_growth", "token_utility", "mass_adoption", "technological_breakthrough"}
  }
}

-- Sentiment selection ranges based on lucky number
local SENTIMENT_RANGES = {
  {min = 0,   max = 199, sentiment = "bearish"},
  {min = 200, max = 399, sentiment = "neutral"},
  {min = 400, max = 699, sentiment = "bullish"},
  {min = 700, max = 999, sentiment = "very_bullish"}
}

-- ============================================================================
-- NFT METADATA CONFIGURATION (Phase 4-1)
-- ============================================================================

-- Base metadata template
local METADATA_TEMPLATE = {
  name = "", -- Will be set dynamically
  description = "Believing in AO's growth",
  strategy = "Maximize $AO",
  image = "https://arweave.net/belieffi-ao-maxi-image-placeholder", -- TODO: Update with actual image URL
  external_url = "", -- Will be set dynamically
  collection = {
    name = "BeliefFi DeFAI NFT Collection",
    family = "AO MAXI"
  }
}

-- Metadata validation rules
local VALIDATION_RULES = {
  required_fields = {"name", "description", "strategy", "image", "lucky_number", "market_sentiment", "attributes"},
  numeric_ranges = {
    lucky_number = {min = 0, max = 999}
  },
  string_patterns = {
    name = "^AO MAXI #%d%d%d$"
  }
}

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

-- Payment Processing (Phase 3-1)
State.payment_records = State.payment_records or {} -- tx_id -> payment_info
State.processed_transactions = State.processed_transactions or {} -- tx_id -> boolean
State.pending_refunds = State.pending_refunds or {} -- address -> amount
State.refund_history = State.refund_history or {} -- tx_id -> refund_info

-- Lucky Number Management (Phase 2-1)
State.lucky_numbers_assigned = State.lucky_numbers_assigned or {} -- nft_id -> lucky_number
State.current_lucky_index = State.current_lucky_index or 1 -- Next index to use from LUCKY_NUMBERS

-- Market Sentiment Management (Phase 2-2)
State.market_sentiments = State.market_sentiments or {} -- nft_id -> market_sentiment
State.sentiment_statistics = State.sentiment_statistics or {
  bearish = 0,
  neutral = 0,
  bullish = 0,
  very_bullish = 0
}

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
-- MINT LIMITATION MANAGEMENT (Phase 1-3)
-- ============================================================================

-- Check detailed mint eligibility for an address
local function checkMintEligibility(address)
  local eligibility = {
    address = address,
    eligible = false,
    reason = "",
    checks = {}
  }
  
  -- Check 1: Valid address format
  eligibility.checks.valid_address = isValidAddress(address)
  if not eligibility.checks.valid_address then
    eligibility.reason = "Invalid address format"
    return eligibility
  end
  
  -- Check 2: Global minting enabled
  eligibility.checks.mint_enabled = State.mint_enabled
  if not eligibility.checks.mint_enabled then
    eligibility.reason = "Minting is currently disabled"
    return eligibility
  end
  
  -- Check 3: Public mint enabled
  eligibility.checks.public_mint_enabled = checkPublicMintEnabled()
  if not eligibility.checks.public_mint_enabled then
    eligibility.reason = "Public mint is not available"
    return eligibility
  end
  
  -- Check 4: Address hasn't already minted (1 per address limit)
  eligibility.checks.not_minted = not (State.minted_by_address[address] or false)
  if not eligibility.checks.not_minted then
    eligibility.reason = "Address has already minted 1 NFT (maximum allowed)"
    return eligibility
  end
  
  -- Check 5: Supply available
  eligibility.checks.supply_available = State.total_minted < MAX_SUPPLY
  if not eligibility.checks.supply_available then
    eligibility.reason = string.format("All NFTs sold out (%d/%d minted)", MAX_SUPPLY, MAX_SUPPLY)
    return eligibility
  end
  
  -- All checks passed
  eligibility.eligible = true
  eligibility.reason = "Address is eligible to mint"
  eligibility.remaining_supply = getRemainingSupply()
  eligibility.mint_price = MINT_PRICE
  
  return eligibility
end

-- Record a successful mint for an address
local function recordMint(address, nftId)
  -- Validate inputs
  if not isValidAddress(address) then
    logError("Invalid address in recordMint", {address = address})
    return false, "Invalid address"
  end
  
  if not nftId or nftId <= 0 or nftId > MAX_SUPPLY then
    logError("Invalid NFT ID in recordMint", {nftId = nftId})
    return false, "Invalid NFT ID"
  end
  
  -- Check if already minted
  if State.minted_by_address[address] then
    logError("Address already minted", {address = address})
    return false, "Address has already minted"
  end
  
  -- Record the mint
  State.minted_by_address[address] = true
  State.nft_owners[nftId] = address
  
  -- Update balances
  initializeBalance(address)
  State.nft_balances[address] = 1  -- Always exactly 1 NFT per address
  
  -- Update global counters
  State.total_minted = State.total_minted + 1
  State.remaining_supply = MAX_SUPPLY - State.total_minted
  
  -- Add to NFT IDs list
  table.insert(State.nft_ids, nftId)
  
  -- Log the successful mint
  logInfo(string.format("Mint recorded: NFT #%d to address %s", nftId, address))
  
  return true, "Mint successfully recorded"
end

-- Get comprehensive mint status
local function getMintStatusDetailed()
  local status = {
    -- Supply information
    supply = {
      maximum = MAX_SUPPLY,
      minted = State.total_minted,
      remaining = getRemainingSupply(),
      percentage_minted = (State.total_minted / MAX_SUPPLY) * 100
    },
    
    -- Mint configuration
    configuration = {
      price = MINT_PRICE,
      price_token = "USDA",
      limit_per_address = MINT_LIMIT_PER_ADDRESS,
      public_mint = checkPublicMintEnabled(),
      mint_enabled = State.mint_enabled
    },
    
    -- Current state
    state = {
      status = "inactive",
      accepting_mints = false,
      message = ""
    },
    
    -- Statistics
    statistics = {
      unique_holders = 0,
      last_mint_id = nil
    }
  }
  
  -- Calculate unique holders
  for address, _ in pairs(State.minted_by_address) do
    status.statistics.unique_holders = status.statistics.unique_holders + 1
  end
  
  -- Get last minted NFT ID
  if #State.nft_ids > 0 then
    status.statistics.last_mint_id = State.nft_ids[#State.nft_ids]
  end
  
  -- Determine current state
  if State.total_minted >= MAX_SUPPLY then
    status.state.status = "sold_out"
    status.state.accepting_mints = false
    status.state.message = "All NFTs have been minted"
  elseif not State.mint_enabled then
    status.state.status = "paused"
    status.state.accepting_mints = false
    status.state.message = "Minting is temporarily paused"
  else
    status.state.status = "active"
    status.state.accepting_mints = true
    status.state.message = string.format("Minting is open (%d NFTs remaining)", getRemainingSupply())
  end
  
  return status
end

-- Enhanced validation for mint requests with detailed checks
local function validateMintRequestDetailed(address, amount)
  local validation = {
    valid = false,
    address = address,
    amount = amount,
    errors = {},
    warnings = {}
  }
  
  -- Check address format
  if not isValidAddress(address) then
    table.insert(validation.errors, "Invalid address format")
  end
  
  -- Check amount (if provided)
  if amount then
    local numAmount = safeToNumber(amount)
    if numAmount ~= safeToNumber(MINT_PRICE) then
      table.insert(validation.errors, string.format("Incorrect payment amount. Required: %s USDA", MINT_PRICE))
    end
  end
  
  -- Check mint eligibility
  local eligibility = checkMintEligibility(address)
  if not eligibility.eligible then
    table.insert(validation.errors, eligibility.reason)
  end
  
  -- Add warnings if close to limits
  if State.total_minted >= MAX_SUPPLY - 10 then
    table.insert(validation.warnings, string.format("Low supply warning: Only %d NFTs remaining", getRemainingSupply()))
  end
  
  -- Set overall validation status
  validation.valid = #validation.errors == 0
  
  return validation
end

-- Get mint history for tracking
local function getMintHistory(limit)
  limit = limit or 10
  local history = {
    total_mints = State.total_minted,
    recent_mints = {},
    addresses_minted = {}
  }
  
  -- Get recent NFT IDs
  local startIdx = math.max(1, #State.nft_ids - limit + 1)
  for i = startIdx, #State.nft_ids do
    local nftId = State.nft_ids[i]
    local owner = State.nft_owners[nftId]
    table.insert(history.recent_mints, {
      nft_id = nftId,
      owner = owner,
      index = i
    })
  end
  
  -- Get list of addresses that have minted
  for address, _ in pairs(State.minted_by_address) do
    table.insert(history.addresses_minted, address)
  end
  
  return history
end

-- Check if we're at or near supply limits
local function checkSupplyLimits()
  local limits = {
    at_maximum = State.total_minted >= MAX_SUPPLY,
    near_maximum = State.total_minted >= MAX_SUPPLY * 0.9,  -- 90% threshold
    remaining = getRemainingSupply(),
    percentage_remaining = (getRemainingSupply() / MAX_SUPPLY) * 100
  }
  
  return limits
end

-- ============================================================================
-- LUCKY NUMBER FUNCTIONS (Phase 2-1)
-- ============================================================================

-- Initialize lucky numbers (called on process start)
local function initializeLuckyNumbers()
  -- TODO: Replace with RandAO integration in the future
  -- Currently using hardcoded values
  logInfo("Lucky Numbers initialized with hardcoded values (MVP)")
  logInfo("Lucky Numbers count: " .. #LUCKY_NUMBERS)
  
  -- Validate we have enough lucky numbers
  if #LUCKY_NUMBERS < MAX_SUPPLY then
    logError("Insufficient lucky numbers defined", {
      required = MAX_SUPPLY,
      available = #LUCKY_NUMBERS
    })
    return false
  end
  
  State.current_lucky_index = State.current_lucky_index or 1
  return true
end

-- Get the next lucky number for minting
local function getNextLuckyNumber()
  -- Check if we have remaining lucky numbers
  if State.current_lucky_index > #LUCKY_NUMBERS then
    logError("No more lucky numbers available", {
      current_index = State.current_lucky_index,
      max_index = #LUCKY_NUMBERS
    })
    return nil
  end
  
  -- Get the lucky number at current index
  local luckyNumber = LUCKY_NUMBERS[State.current_lucky_index]
  
  -- Validate lucky number is in range
  if luckyNumber < 0 or luckyNumber > 999 then
    logError("Lucky number out of range", {
      lucky_number = luckyNumber,
      index = State.current_lucky_index
    })
    return nil
  end
  
  -- Increment index for next use
  State.current_lucky_index = State.current_lucky_index + 1
  
  return luckyNumber
end

-- Record lucky number assignment for an NFT
local function recordLuckyNumber(nftId, luckyNumber)
  -- Validate inputs
  if not nftId or nftId <= 0 or nftId > MAX_SUPPLY then
    logError("Invalid NFT ID for lucky number", {nft_id = nftId})
    return false
  end
  
  if not luckyNumber or luckyNumber < 0 or luckyNumber > 999 then
    logError("Invalid lucky number", {lucky_number = luckyNumber})
    return false
  end
  
  -- Check if already assigned
  if State.lucky_numbers_assigned[nftId] then
    logError("Lucky number already assigned", {
      nft_id = nftId,
      existing_number = State.lucky_numbers_assigned[nftId]
    })
    return false
  end
  
  -- Record the assignment
  State.lucky_numbers_assigned[nftId] = luckyNumber
  
  logInfo(string.format("Lucky number %d assigned to NFT #%d", luckyNumber, nftId))
  
  return true
end

-- Get lucky number for a specific NFT
local function getLuckyNumberForNFT(nftId)
  return State.lucky_numbers_assigned[nftId]
end

-- Get lucky number statistics
local function getLuckyNumberStats()
  local stats = {
    total_assigned = 0,
    next_index = State.current_lucky_index,
    remaining = #LUCKY_NUMBERS - (State.current_lucky_index - 1),
    assignments = {}
  }
  
  -- Count assignments and build list
  for nftId, luckyNumber in pairs(State.lucky_numbers_assigned) do
    stats.total_assigned = stats.total_assigned + 1
    table.insert(stats.assignments, {
      nft_id = nftId,
      lucky_number = luckyNumber
    })
  end
  
  -- Sort assignments by NFT ID
  table.sort(stats.assignments, function(a, b) return a.nft_id < b.nft_id end)
  
  return stats
end

-- Preview what the next lucky number would be (without consuming it)
local function previewNextLuckyNumber()
  if State.current_lucky_index > #LUCKY_NUMBERS then
    return nil
  end
  return LUCKY_NUMBERS[State.current_lucky_index]
end

-- ============================================================================
-- MARKET SENTIMENT FUNCTIONS (Phase 2-2)
-- ============================================================================

-- Initialize sentiment patterns (called on process start)
local function initializeSentimentPatterns()
  -- TODO: Replace with Apus Network integration in the future
  -- Currently using hardcoded patterns
  logInfo("Market Sentiment patterns initialized with hardcoded data (MVP)")
  logInfo("Sentiment patterns: " .. json.encode({"bearish", "neutral", "bullish", "very_bullish"}))
  
  -- Validate sentiment patterns
  for sentimentType, pattern in pairs(SENTIMENT_PATTERNS) do
    if not pattern.ao_sentiment or not pattern.confidence_score or not pattern.market_factors then
      logError("Invalid sentiment pattern", {sentiment_type = sentimentType})
      return false
    end
  end
  
  -- Initialize sentiment statistics if not exists
  State.sentiment_statistics = State.sentiment_statistics or {
    bearish = 0,
    neutral = 0,
    bullish = 0,
    very_bullish = 0
  }
  
  return true
end

-- Get sentiment type based on lucky number
local function getSentimentByLuckyNumber(luckyNumber)
  -- Validate input
  if not luckyNumber or luckyNumber < 0 or luckyNumber > 999 then
    logError("Invalid lucky number for sentiment", {lucky_number = luckyNumber})
    return nil
  end
  
  -- Find matching range
  for _, range in ipairs(SENTIMENT_RANGES) do
    if luckyNumber >= range.min and luckyNumber <= range.max then
      return range.sentiment
    end
  end
  
  -- Default fallback (should not happen with valid input)
  logError("No sentiment range found for lucky number", {lucky_number = luckyNumber})
  return "neutral"
end

-- Generate complete market sentiment object
local function generateMarketSentiment(luckyNumber)
  -- Get sentiment type based on lucky number
  local sentimentType = getSentimentByLuckyNumber(luckyNumber)
  if not sentimentType then
    return nil
  end
  
  -- Get pattern for this sentiment
  local pattern = SENTIMENT_PATTERNS[sentimentType]
  if not pattern then
    logError("No pattern found for sentiment type", {sentiment_type = sentimentType})
    return nil
  end
  
  -- Create market sentiment object
  local marketSentiment = {
    ao_sentiment = pattern.ao_sentiment,
    confidence_score = pattern.confidence_score,
    analysis_timestamp = getCurrentTimestamp(),
    market_factors = {},
    sentiment_source = "Powered by Apus Network",
    lucky_number_basis = luckyNumber
  }
  
  -- Copy market factors (deep copy)
  for _, factor in ipairs(pattern.market_factors) do
    table.insert(marketSentiment.market_factors, factor)
  end
  
  return marketSentiment
end

-- Format sentiment data for display/API
local function formatSentimentData(marketSentiment)
  if not marketSentiment then
    return nil
  end
  
  return {
    sentiment = marketSentiment.ao_sentiment,
    confidence = string.format("%.1f%%", marketSentiment.confidence_score * 100),
    timestamp = marketSentiment.analysis_timestamp,
    factors = table.concat(marketSentiment.market_factors, ", "),
    source = marketSentiment.sentiment_source,
    raw = marketSentiment
  }
end

-- Record market sentiment assignment for an NFT
local function recordMarketSentiment(nftId, marketSentiment)
  -- Validate inputs
  if not nftId or nftId <= 0 or nftId > MAX_SUPPLY then
    logError("Invalid NFT ID for market sentiment", {nft_id = nftId})
    return false
  end
  
  if not marketSentiment or not marketSentiment.ao_sentiment then
    logError("Invalid market sentiment object", {market_sentiment = marketSentiment})
    return false
  end
  
  -- Check if already assigned
  if State.market_sentiments[nftId] then
    logError("Market sentiment already assigned", {
      nft_id = nftId,
      existing_sentiment = State.market_sentiments[nftId].ao_sentiment
    })
    return false
  end
  
  -- Record the assignment
  State.market_sentiments[nftId] = marketSentiment
  
  -- Update statistics
  local sentimentType = marketSentiment.ao_sentiment
  if State.sentiment_statistics[sentimentType] then
    State.sentiment_statistics[sentimentType] = State.sentiment_statistics[sentimentType] + 1
  end
  
  logInfo(string.format("Market sentiment '%s' assigned to NFT #%d", sentimentType, nftId))
  
  return true
end

-- Get market sentiment for a specific NFT
local function getMarketSentimentForNFT(nftId)
  return State.market_sentiments[nftId]
end

-- Get market sentiment statistics
local function getMarketSentimentStats()
  local stats = {
    total_assigned = 0,
    distribution = {},
    recent_sentiments = {}
  }
  
  -- Calculate distribution
  for sentimentType, count in pairs(State.sentiment_statistics) do
    stats.total_assigned = stats.total_assigned + count
    stats.distribution[sentimentType] = {
      count = count,
      percentage = 0  -- Will calculate after total is known
    }
  end
  
  -- Calculate percentages
  if stats.total_assigned > 0 then
    for sentimentType, data in pairs(stats.distribution) do
      data.percentage = (data.count / stats.total_assigned) * 100
    end
  end
  
  -- Get recent sentiment assignments
  local recentCount = 0
  for nftId = math.max(1, State.total_minted - 9), State.total_minted do
    local sentiment = State.market_sentiments[nftId]
    if sentiment then
      table.insert(stats.recent_sentiments, {
        nft_id = nftId,
        sentiment = sentiment.ao_sentiment,
        confidence = sentiment.confidence_score
      })
      recentCount = recentCount + 1
    end
  end
  
  return stats
end

-- Generate sentiment and lucky number combination for minting
local function generateNFTData(nftId)
  -- Generate lucky number
  local luckyNumber = getNextLuckyNumber()
  if not luckyNumber then
    return nil, "No lucky number available"
  end
  
  -- Generate market sentiment based on lucky number
  local marketSentiment = generateMarketSentiment(luckyNumber)
  if not marketSentiment then
    return nil, "Failed to generate market sentiment"
  end
  
  -- Return combined data
  return {
    nft_id = nftId,
    lucky_number = luckyNumber,
    market_sentiment = marketSentiment
  }, nil
end

-- ============================================================================
-- PAYMENT PROCESSING FUNCTIONS (Phase 3-1)
-- ============================================================================

-- Validate payment amount (exactly 1 USDA)
local function validatePaymentAmount(amount)
  if type(amount) ~= "string" then
    return false, "Payment amount must be a string"
  end
  
  local expectedAmount = MINT_PRICE
  if amount ~= expectedAmount then
    local numAmount = tonumber(amount) or 0
    local numExpected = tonumber(expectedAmount) or 0
    
    if numAmount < numExpected then
      return false, "Insufficient payment. Required: 1 USDA"
    elseif numAmount > numExpected then
      return false, "Overpayment detected", numAmount - numExpected
    end
  end
  
  return true, "Payment amount correct"
end

-- Check if transaction was already processed
local function isTransactionProcessed(txId)
  return State.processed_transactions[txId] ~= nil
end

-- Record transaction as processed
local function markTransactionProcessed(txId, details)
  State.processed_transactions[txId] = {
    processed_at = getCurrentTimestamp(),
    details = details or {}
  }
end

-- Process payment record
local function recordPayment(txId, fromAddress, amount, timestamp)
  local paymentInfo = {
    transaction_id = txId,
    from_address = fromAddress,
    amount = amount,
    timestamp = timestamp or getCurrentTimestamp(),
    status = "received"
  }
  
  State.payment_records[txId] = paymentInfo
  logInfo(string.format("Payment recorded: %s USDA from %s", amount, fromAddress))
  
  return paymentInfo
end

-- Process refund
local function processRefund(toAddress, amount, reason, originalTxId)
  -- Validate inputs
  if not isValidAddress(toAddress) then
    logError("Invalid address for refund", {address = toAddress})
    return false, "Invalid address"
  end
  
  if not amount or tonumber(amount) <= 0 then
    logError("Invalid refund amount", {amount = amount})
    return false, "Invalid amount"
  end
  
  -- Create refund record
  local refundInfo = {
    to_address = toAddress,
    amount = amount,
    reason = reason or "Refund",
    original_transaction = originalTxId,
    refund_timestamp = getCurrentTimestamp(),
    status = "pending"
  }
  
  -- Add to pending refunds
  State.pending_refunds[toAddress] = (State.pending_refunds[toAddress] or "0")
  local currentPending = tonumber(State.pending_refunds[toAddress]) or 0
  local refundAmount = tonumber(amount) or 0
  State.pending_refunds[toAddress] = tostring(currentPending + refundAmount)
  
  -- Send refund message
  ao.send({
    Target = USDA_PROCESS_ID,
    Action = "Transfer",
    Recipient = toAddress,
    Quantity = amount,
    ["X-Reason"] = reason,
    ["X-Original-TX"] = originalTxId or ""
  })
  
  -- Record refund
  local refundTxId = originalTxId .. "_refund_" .. os.time()
  State.refund_history[refundTxId] = refundInfo
  
  logInfo(string.format("Refund processed: %s USDA to %s (Reason: %s)", amount, toAddress, reason))
  
  return true, "Refund processed"
end

-- Get payment status for an address
local function getPaymentStatus(address)
  local status = {
    address = address,
    has_paid = false,
    payment_amount = "0",
    transaction_id = nil,
    pending_refund = State.pending_refunds[address] or "0"
  }
  
  -- Check payment records
  for txId, payment in pairs(State.payment_records) do
    if payment.from_address == address and payment.status == "received" then
      status.has_paid = true
      status.payment_amount = payment.amount
      status.transaction_id = txId
      break
    end
  end
  
  return status
end

-- Validate Credit-Notice message
local function validateCreditNotice(msg)
  -- Check sender is USDA token process
  if msg.From ~= USDA_PROCESS_ID then
    return false, "Payment not from USDA token process"
  end
  
  -- Check action
  if msg.Action ~= "Credit-Notice" then
    return false, "Not a credit notice"
  end
  
  -- Extract payment details
  local amount = msg.Quantity or msg.Amount
  local fromAddress = msg.Sender or msg["From-Process"]
  
  if not amount then
    return false, "No payment amount specified"
  end
  
  if not fromAddress or not isValidAddress(fromAddress) then
    return false, "Invalid sender address"
  end
  
  return true, {
    amount = amount,
    from_address = fromAddress,
    transaction_id = msg.Id
  }
end

-- Process complete payment and mint flow
local function processPaymentAndMint(paymentDetails)
  local fromAddress = paymentDetails.from_address
  local amount = paymentDetails.amount
  local txId = paymentDetails.transaction_id
  
  -- Check if transaction already processed
  if isTransactionProcessed(txId) then
    logError("Transaction already processed", {tx_id = txId})
    return createErrorResponse("Transaction already processed")
  end
  
  -- Validate payment amount
  local isValidAmount, message, excessAmount = validatePaymentAmount(amount)
  if not isValidAmount then
    -- If overpayment, process refund for excess
    if excessAmount and excessAmount > 0 then
      processRefund(fromAddress, tostring(excessAmount), "Overpayment refunded", txId)
      -- Continue with mint using correct amount
      amount = MINT_PRICE
    else
      -- Insufficient payment - refund everything
      processRefund(fromAddress, amount, "Insufficient payment", txId)
      markTransactionProcessed(txId, {error = message})
      return createErrorResponse(message)
    end
  end
  
  -- Check mint eligibility
  local eligibility = checkMintEligibility(fromAddress)
  if not eligibility.eligible then
    -- Refund full amount
    processRefund(fromAddress, amount, eligibility.reason, txId)
    markTransactionProcessed(txId, {error = eligibility.reason})
    return createErrorResponse(eligibility.reason)
  end
  
  -- Record payment
  recordPayment(txId, fromAddress, amount, getCurrentTimestamp())
  
  -- Generate NFT data (lucky number + market sentiment)
  local nftId = generateNextNFTId()
  if not nftId then
    processRefund(fromAddress, amount, "No more NFTs available", txId)
    markTransactionProcessed(txId, {error = "Sold out"})
    return createErrorResponse("All NFTs have been minted")
  end
  
  local nftData, error = generateNFTData(nftId)
  if not nftData then
    processRefund(fromAddress, amount, "Failed to generate NFT data: " .. (error or "unknown"), txId)
    markTransactionProcessed(txId, {error = error})
    return createErrorResponse("Mint failed: " .. (error or "unknown error"))
  end
  
  -- Record mint and assignments
  local success, mintError = recordMint(fromAddress, nftId)
  if not success then
    processRefund(fromAddress, amount, mintError, txId)
    markTransactionProcessed(txId, {error = mintError})
    return createErrorResponse(mintError)
  end
  
  -- Record lucky number and market sentiment
  recordLuckyNumber(nftId, nftData.lucky_number)
  recordMarketSentiment(nftId, nftData.market_sentiment)
  
  -- Generate and store NFT metadata
  local metadata, metadataError = generateNFTMetadata(nftId, fromAddress, nftData.lucky_number, nftData.market_sentiment)
  if metadata then
    local metadataStored, storeError = storeNFTMetadata(nftId, metadata)
    if not metadataStored then
      logError("Failed to store metadata", {nft_id = nftId, error = storeError})
      -- Continue anyway as mint was successful
    end
  else
    logError("Failed to generate metadata", {nft_id = nftId, error = metadataError})
    -- Continue anyway as mint was successful
  end
  
  -- Record revenue using enhanced function
  local revenueSuccess, revenueError = recordRevenue(nftId, amount)
  if not revenueSuccess then
    logError("Failed to record revenue", {nft_id = nftId, error = revenueError})
    -- Continue anyway as mint was successful
  end
  
  -- Mark transaction as successfully processed
  markTransactionProcessed(txId, {
    nft_id = nftId,
    mint_success = true,
    lucky_number = nftData.lucky_number,
    sentiment = nftData.market_sentiment.ao_sentiment
  })
  
  logInfo(string.format("Successful mint: NFT #%d to %s", nftId, fromAddress))
  
  return createSuccessResponse({
    nft_id = nftId,
    owner = fromAddress,
    lucky_number = nftData.lucky_number,
    market_sentiment = nftData.market_sentiment,
    transaction_id = txId,
    message = string.format("Successfully minted NFT #%d", nftId)
  })
end

-- Get payment statistics
local function getPaymentStats()
  local stats = {
    total_payments_received = 0,
    total_revenue = State.total_revenue,
    pending_refunds_count = 0,
    pending_refunds_amount = "0",
    processed_transactions = 0,
    recent_payments = {}
  }
  
  -- Count payments
  for _, payment in pairs(State.payment_records) do
    if payment.status == "received" then
      stats.total_payments_received = stats.total_payments_received + 1
      table.insert(stats.recent_payments, {
        from = payment.from_address,
        amount = payment.amount,
        timestamp = payment.timestamp
      })
    end
  end
  
  -- Count pending refunds
  local totalPendingRefunds = 0
  for address, amount in pairs(State.pending_refunds) do
    local pendingAmount = tonumber(amount) or 0
    if pendingAmount > 0 then
      stats.pending_refunds_count = stats.pending_refunds_count + 1
      totalPendingRefunds = totalPendingRefunds + pendingAmount
    end
  end
  stats.pending_refunds_amount = tostring(totalPendingRefunds)
  
  -- Count processed transactions
  for _, _ in pairs(State.processed_transactions) do
    stats.processed_transactions = stats.processed_transactions + 1
  end
  
  -- Sort recent payments by timestamp (most recent first)
  table.sort(stats.recent_payments, function(a, b) return a.timestamp > b.timestamp end)
  
  -- Limit to last 10
  if #stats.recent_payments > 10 then
    local limited = {}
    for i = 1, 10 do
      limited[i] = stats.recent_payments[i]
    end
    stats.recent_payments = limited
  end
  
  return stats
end

-- ============================================================================
-- FUND MANAGEMENT FUNCTIONS (Phase 3-2 - MVP Simplified)
-- ============================================================================

-- Record revenue from a successful mint
local function recordRevenue(nftId, amount)
  -- Validate inputs
  if not nftId or nftId <= 0 or nftId > MAX_SUPPLY then
    logError("Invalid NFT ID for revenue recording", {nft_id = nftId})
    return false, "Invalid NFT ID"
  end
  
  if not amount or tonumber(amount) <= 0 then
    logError("Invalid revenue amount", {amount = amount})
    return false, "Invalid amount"
  end
  
  -- Check if already recorded
  if State.revenue_records[nftId] then
    logError("Revenue already recorded for NFT", {nft_id = nftId})
    return false, "Revenue already recorded"
  end
  
  -- Record revenue for this NFT
  State.revenue_records[nftId] = amount
  
  -- Update total revenue
  local currentTotal = tonumber(State.total_revenue) or 0
  local revenueAmount = tonumber(amount) or 0
  State.total_revenue = tostring(currentTotal + revenueAmount)
  
  -- Update process balance (in-process fund management)
  local currentBalance = tonumber(State.process_balance) or 0
  State.process_balance = tostring(currentBalance + revenueAmount)
  
  logInfo(string.format("Revenue recorded: %s USDA for NFT #%d (Total: %s USDA)", amount, nftId, State.total_revenue))
  
  return true, "Revenue recorded successfully"
end

-- Get current process balance
local function getProcessBalance()
  return {
    balance = State.process_balance or "0",
    balance_usda = tonumber(State.process_balance) or 0,
    total_revenue = State.total_revenue or "0",
    total_revenue_usda = tonumber(State.total_revenue) or 0,
    currency = "USDA"
  }
end

-- Enhanced refund processing with balance management
local function processRefundEnhanced(toAddress, amount, reason, originalTxId)
  -- Validate inputs
  if not isValidAddress(toAddress) then
    logError("Invalid address for refund", {address = toAddress})
    return false, "Invalid address"
  end
  
  local refundAmount = tonumber(amount) or 0
  if refundAmount <= 0 then
    logError("Invalid refund amount", {amount = amount})
    return false, "Invalid amount"
  end
  
  -- Check if we have sufficient balance for refund
  local currentBalance = tonumber(State.process_balance) or 0
  if currentBalance < refundAmount then
    logError("Insufficient balance for refund", {
      required = refundAmount,
      available = currentBalance
    })
    return false, "Insufficient balance"
  end
  
  -- Create refund record
  local refundInfo = {
    to_address = toAddress,
    amount = amount,
    reason = reason or "Refund",
    original_transaction = originalTxId,
    refund_timestamp = getCurrentTimestamp(),
    status = "processing"
  }
  
  -- Update pending refunds
  State.pending_refunds[toAddress] = (State.pending_refunds[toAddress] or "0")
  local currentPending = tonumber(State.pending_refunds[toAddress]) or 0
  State.pending_refunds[toAddress] = tostring(currentPending + refundAmount)
  
  -- Deduct from process balance
  State.process_balance = tostring(currentBalance - refundAmount)
  
  -- Send refund message
  local success, error = pcall(function()
    ao.send({
      Target = USDA_PROCESS_ID,
      Action = "Transfer",
      Recipient = toAddress,
      Quantity = amount,
      ["X-Reason"] = reason,
      ["X-Original-TX"] = originalTxId or "",
      ["X-Refund-Type"] = "automated"
    })
  end)
  
  if not success then
    -- Restore balance if send failed
    State.process_balance = tostring(currentBalance)
    logError("Failed to send refund", {error = error})
    return false, "Refund failed"
  end
  
  -- Record successful refund
  refundInfo.status = "sent"
  local refundTxId = (originalTxId or "manual") .. "_refund_" .. os.time()
  State.refund_history[refundTxId] = refundInfo
  
  logInfo(string.format("Enhanced refund processed: %s USDA to %s (Balance: %s USDA)", 
    amount, toAddress, State.process_balance))
  
  return true, "Refund processed successfully"
end

-- Generate comprehensive revenue report
local function getRevenueReport()
  local report = {
    summary = {
      total_revenue = State.total_revenue or "0",
      total_revenue_usda = tonumber(State.total_revenue) or 0,
      process_balance = State.process_balance or "0",
      process_balance_usda = tonumber(State.process_balance) or 0,
      nfts_sold = 0,
      average_revenue_per_nft = 0
    },
    revenue_by_nft = {},
    refund_summary = {
      total_refunds_issued = 0,
      total_refund_amount = "0",
      pending_refunds = 0,
      pending_refund_amount = "0"
    },
    timestamp = getCurrentTimestamp()
  }
  
  -- Calculate NFT revenue details
  for nftId, amount in pairs(State.revenue_records) do
    report.summary.nfts_sold = report.summary.nfts_sold + 1
    table.insert(report.revenue_by_nft, {
      nft_id = nftId,
      revenue = amount,
      revenue_usda = tonumber(amount) or 0,
      owner = State.nft_owners[nftId]
    })
  end
  
  -- Calculate average revenue per NFT
  if report.summary.nfts_sold > 0 then
    report.summary.average_revenue_per_nft = report.summary.total_revenue_usda / report.summary.nfts_sold
  end
  
  -- Sort revenue by NFT ID
  table.sort(report.revenue_by_nft, function(a, b) return a.nft_id < b.nft_id end)
  
  -- Calculate refund statistics
  local totalRefunds = 0
  local totalRefundAmount = 0
  for _, refund in pairs(State.refund_history) do
    if refund.status == "sent" then
      totalRefunds = totalRefunds + 1
      totalRefundAmount = totalRefundAmount + (tonumber(refund.amount) or 0)
    end
  end
  
  report.refund_summary.total_refunds_issued = totalRefunds
  report.refund_summary.total_refund_amount = tostring(totalRefundAmount)
  
  -- Calculate pending refunds
  local pendingRefunds = 0
  local pendingAmount = 0
  for address, amount in pairs(State.pending_refunds) do
    local pending = tonumber(amount) or 0
    if pending > 0 then
      pendingRefunds = pendingRefunds + 1
      pendingAmount = pendingAmount + pending
    end
  end
  
  report.refund_summary.pending_refunds = pendingRefunds
  report.refund_summary.pending_refund_amount = tostring(pendingAmount)
  
  return report
end

-- Get fund management status
local function getFundManagementStatus()
  local status = {
    mode = "in_process_management",  -- MVP mode
    smart_wallet_enabled = false,   -- Disabled in MVP
    balance_info = getProcessBalance(),
    revenue_info = {
      total_collected = State.total_revenue or "0",
      nfts_generating_revenue = 0,
      last_revenue_nft = nil
    },
    refund_info = {
      total_refunded = "0",
      refunds_processed = 0,
      pending_refunds = 0
    }
  }
  
  -- Count revenue-generating NFTs
  for nftId, _ in pairs(State.revenue_records) do
    status.revenue_info.nfts_generating_revenue = status.revenue_info.nfts_generating_revenue + 1
    status.revenue_info.last_revenue_nft = math.max(status.revenue_info.last_revenue_nft or 0, nftId)
  end
  
  -- Calculate refund totals
  local totalRefunded = 0
  local refundsProcessed = 0
  for _, refund in pairs(State.refund_history) do
    if refund.status == "sent" then
      totalRefunded = totalRefunded + (tonumber(refund.amount) or 0)
      refundsProcessed = refundsProcessed + 1
    end
  end
  
  status.refund_info.total_refunded = tostring(totalRefunded)
  status.refund_info.refunds_processed = refundsProcessed
  
  -- Count pending refunds
  for _, amount in pairs(State.pending_refunds) do
    if (tonumber(amount) or 0) > 0 then
      status.refund_info.pending_refunds = status.refund_info.pending_refunds + 1
    end
  end
  
  return status
end

-- ============================================================================
-- NFT METADATA MANAGEMENT FUNCTIONS (Phase 4-1)
-- ============================================================================

-- Format number with zero padding
local function formatNumberWithZeroPad(number, digits)
  local str = tostring(number)
  while #str < digits do
    str = "0" .. str
  end
  return str
end

-- Generate NFT name with padded ID
local function generateNFTName(nftId)
  return "AO MAXI #" .. formatNumberWithZeroPad(nftId, 3)
end

-- Generate external URL for NFT
local function generateExternalURL(nftId)
  return "https://belieffi.arweave.net/nft/" .. tostring(nftId)
end

-- Validate metadata structure and content
local function validateMetadata(metadata)
  local validation = {
    valid = true,
    errors = {},
    warnings = {}
  }
  
  -- Check required fields
  for _, field in ipairs(VALIDATION_RULES.required_fields) do
    if not metadata[field] then
      table.insert(validation.errors, "Missing required field: " .. field)
      validation.valid = false
    end
  end
  
  -- Check data types and values
  if metadata.lucky_number then
    if type(metadata.lucky_number) ~= "number" then
      table.insert(validation.errors, "lucky_number must be a number")
      validation.valid = false
    elseif metadata.lucky_number < VALIDATION_RULES.numeric_ranges.lucky_number.min or 
           metadata.lucky_number > VALIDATION_RULES.numeric_ranges.lucky_number.max then
      table.insert(validation.errors, "lucky_number out of range (0-999)")
      validation.valid = false
    end
  end
  
  -- Check name format
  if metadata.name then
    if not string.match(metadata.name, VALIDATION_RULES.string_patterns.name) then
      table.insert(validation.errors, "Invalid name format")
      validation.valid = false
    end
  end
  
  -- Check market sentiment structure
  if metadata.market_sentiment then
    local sentiment = metadata.market_sentiment
    if not sentiment.ao_sentiment or not sentiment.confidence_score then
      table.insert(validation.errors, "Invalid market_sentiment structure")
      validation.valid = false
    elseif type(sentiment.confidence_score) ~= "number" or 
           sentiment.confidence_score < 0 or sentiment.confidence_score > 1 then
      table.insert(validation.errors, "confidence_score must be between 0 and 1")
      validation.valid = false
    end
  end
  
  -- Check attributes array
  if metadata.attributes then
    if type(metadata.attributes) ~= "table" then
      table.insert(validation.errors, "attributes must be an array")
      validation.valid = false
    else
      for i, attr in ipairs(metadata.attributes) do
        if not attr.trait_type or not attr.value then
          table.insert(validation.errors, "Invalid attribute structure at index " .. i)
          validation.valid = false
        end
      end
    end
  end
  
  return validation
end

-- Generate complete NFT metadata
local function generateNFTMetadata(nftId, owner, luckyNumber, marketSentiment)
  -- Validate inputs
  if not nftId or nftId <= 0 or nftId > MAX_SUPPLY then
    return nil, "Invalid NFT ID"
  end
  
  if not isValidAddress(owner) then
    return nil, "Invalid owner address"
  end
  
  if not luckyNumber or luckyNumber < 0 or luckyNumber > 999 then
    return nil, "Invalid lucky number"
  end
  
  if not marketSentiment or not marketSentiment.ao_sentiment then
    return nil, "Invalid market sentiment"
  end
  
  -- Create base metadata from template
  local metadata = {
    name = generateNFTName(nftId),
    description = METADATA_TEMPLATE.description,
    strategy = METADATA_TEMPLATE.strategy,
    image = METADATA_TEMPLATE.image,
    external_url = generateExternalURL(nftId),
    collection = {
      name = METADATA_TEMPLATE.collection.name,
      family = METADATA_TEMPLATE.collection.family
    },
    
    -- Dynamic data
    lucky_number = luckyNumber,
    market_sentiment = {
      ao_sentiment = marketSentiment.ao_sentiment,
      confidence_score = marketSentiment.confidence_score,
      analysis_timestamp = marketSentiment.analysis_timestamp,
      market_factors = {},
      sentiment_source = marketSentiment.sentiment_source,
      lucky_number_basis = luckyNumber
    },
    
    -- NFT details
    owner = owner,
    minted_at = getCurrentTimestamp(),
    token_id = nftId,
    
    -- Atomic Assets compliance
    standard = "Atomic Assets",
    version = "1.0"
  }
  
  -- Copy market factors (deep copy)
  for _, factor in ipairs(marketSentiment.market_factors or {}) do
    table.insert(metadata.market_sentiment.market_factors, factor)
  end
  
  -- Generate attributes array
  metadata.attributes = {
    {
      trait_type = "Lucky Number",
      value = luckyNumber,
      display_type = "number"
    },
    {
      trait_type = "Market Sentiment",
      value = marketSentiment.ao_sentiment,
      display_type = "string"
    },
    {
      trait_type = "Confidence Score", 
      value = math.floor(marketSentiment.confidence_score * 100) .. "%",
      display_type = "string"
    },
    {
      trait_type = "Strategy",
      value = "AO MAXI",
      display_type = "string"
    },
    {
      trait_type = "Collection",
      value = "BeliefFi DeFAI",
      display_type = "string"
    },
    {
      trait_type = "Rarity Tier",
      value = getSentimentRarityTier(marketSentiment.ao_sentiment),
      display_type = "string"
    }
  }
  
  -- Add market factors as attributes
  for _, factor in ipairs(metadata.market_sentiment.market_factors) do
    table.insert(metadata.attributes, {
      trait_type = "Market Factor",
      value = factor,
      display_type = "string"
    })
  end
  
  return metadata, nil
end

-- Get sentiment rarity tier for attributes
local function getSentimentRarityTier(sentiment)
  local rarityMap = {
    very_bullish = "Legendary",
    bullish = "Rare", 
    neutral = "Common",
    bearish = "Uncommon"
  }
  return rarityMap[sentiment] or "Common"
end

-- Store metadata for an NFT
local function storeNFTMetadata(nftId, metadata)
  -- Validate metadata before storing
  local validation = validateMetadata(metadata)
  if not validation.valid then
    logError("Invalid metadata for storage", {
      nft_id = nftId,
      errors = validation.errors
    })
    return false, "Metadata validation failed"
  end
  
  -- Store metadata
  State.nft_metadata[nftId] = metadata
  
  logInfo(string.format("Metadata stored for NFT #%d", nftId))
  
  return true, "Metadata stored successfully"
end

-- Retrieve metadata for an NFT
local function getMetadata(nftId)
  if not nftId or nftId <= 0 or nftId > MAX_SUPPLY then
    return nil, "Invalid NFT ID"
  end
  
  local metadata = State.nft_metadata[nftId]
  if not metadata then
    return nil, "Metadata not found"
  end
  
  return metadata, nil
end

-- Update metadata for an NFT (limited updates allowed)
local function updateMetadata(nftId, updates)
  -- Get existing metadata
  local existingMetadata, error = getMetadata(nftId)
  if not existingMetadata then
    return false, error
  end
  
  -- Only allow certain fields to be updated
  local allowedUpdates = {"external_url", "image", "description"}
  local updatedMetadata = {}
  
  -- Copy existing metadata
  for key, value in pairs(existingMetadata) do
    updatedMetadata[key] = value
  end
  
  -- Apply allowed updates
  for key, value in pairs(updates) do
    if not table.contains(allowedUpdates, key) then
      logError("Update not allowed for field", {field = key})
      return false, "Field update not allowed: " .. key
    end
    updatedMetadata[key] = value
  end
  
  -- Validate updated metadata
  local validation = validateMetadata(updatedMetadata)
  if not validation.valid then
    return false, "Updated metadata validation failed"
  end
  
  -- Store updated metadata
  State.nft_metadata[nftId] = updatedMetadata
  
  logInfo(string.format("Metadata updated for NFT #%d", nftId))
  
  return true, "Metadata updated successfully"
end

-- Helper function to check if table contains value
local function table.contains(table, value)
  for _, v in pairs(table) do
    if v == value then
      return true
    end
  end
  return false
end

-- Get metadata statistics
local function getMetadataStats()
  local stats = {
    total_metadata_stored = 0,
    sentiment_distribution = {
      bearish = 0,
      neutral = 0,
      bullish = 0,
      very_bullish = 0
    },
    lucky_number_ranges = {
      low = 0,    -- 0-199
      medium = 0, -- 200-499
      high = 0,   -- 500-799
      max = 0     -- 800-999
    },
    average_confidence = 0
  }
  
  local totalConfidence = 0
  
  for nftId, metadata in pairs(State.nft_metadata) do
    stats.total_metadata_stored = stats.total_metadata_stored + 1
    
    -- Count sentiment distribution
    if metadata.market_sentiment and metadata.market_sentiment.ao_sentiment then
      local sentiment = metadata.market_sentiment.ao_sentiment
      if stats.sentiment_distribution[sentiment] then
        stats.sentiment_distribution[sentiment] = stats.sentiment_distribution[sentiment] + 1
      end
      
      -- Add to confidence calculation
      if metadata.market_sentiment.confidence_score then
        totalConfidence = totalConfidence + metadata.market_sentiment.confidence_score
      end
    end
    
    -- Count lucky number ranges
    if metadata.lucky_number then
      local ln = metadata.lucky_number
      if ln <= 199 then
        stats.lucky_number_ranges.low = stats.lucky_number_ranges.low + 1
      elseif ln <= 499 then
        stats.lucky_number_ranges.medium = stats.lucky_number_ranges.medium + 1
      elseif ln <= 799 then
        stats.lucky_number_ranges.high = stats.lucky_number_ranges.high + 1
      else
        stats.lucky_number_ranges.max = stats.lucky_number_ranges.max + 1
      end
    end
  end
  
  -- Calculate average confidence
  if stats.total_metadata_stored > 0 then
    stats.average_confidence = totalConfidence / stats.total_metadata_stored
  end
  
  return stats
end

-- Generate metadata for all existing NFTs (utility function)
local function regenerateAllMetadata()
  local regenerated = 0
  local errors = {}
  
  for nftId = 1, State.total_minted do
    local owner = State.nft_owners[nftId]
    local luckyNumber = State.lucky_numbers_assigned[nftId]
    local marketSentiment = State.market_sentiments[nftId]
    
    if owner and luckyNumber and marketSentiment then
      local metadata, error = generateNFTMetadata(nftId, owner, luckyNumber, marketSentiment)
      if metadata then
        local stored, storeError = storeNFTMetadata(nftId, metadata)
        if stored then
          regenerated = regenerated + 1
        else
          table.insert(errors, {nft_id = nftId, error = storeError})
        end
      else
        table.insert(errors, {nft_id = nftId, error = error})
      end
    else
      table.insert(errors, {nft_id = nftId, error = "Missing required data"})
    end
  end
  
  return {
    regenerated = regenerated,
    errors = errors,
    total_processed = State.total_minted
  }
end

-- ============================================================================
-- MINT EXECUTION FUNCTIONS (Phase 4-2)
-- ============================================================================

-- Generate next available NFT ID
local function generateNFTId()
  local nextId = State.total_minted + 1
  if nextId > MAX_SUPPLY then
    logError("Maximum supply reached", {
      current_supply = State.total_minted,
      max_supply = MAX_SUPPLY
    })
    return nil, "Maximum supply reached"
  end
  
  return nextId, nil
end

-- Set ownership for an NFT
local function setOwnership(nftId, owner)
  -- Validate inputs
  if not nftId or nftId <= 0 or nftId > MAX_SUPPLY then
    logError("Invalid NFT ID for ownership", {nft_id = nftId})
    return false, "Invalid NFT ID"
  end
  
  if not isValidAddress(owner) then
    logError("Invalid owner address", {address = owner})
    return false, "Invalid address"
  end
  
  -- Check if ownership already set
  if State.nft_owners[nftId] then
    logError("Ownership already set", {
      nft_id = nftId,
      existing_owner = State.nft_owners[nftId],
      new_owner = owner
    })
    return false, "Ownership already set"
  end
  
  -- Set ownership
  State.nft_owners[nftId] = owner
  
  -- Update balance
  initializeBalance(owner)
  State.nft_balances[owner] = (State.nft_balances[owner] or 0) + 1
  
  logInfo(string.format("Ownership set: NFT #%d to %s", nftId, owner))
  
  return true, "Ownership set successfully"
end

-- Update supply counters
local function updateSupply()
  State.remaining_supply = MAX_SUPPLY - State.total_minted
  
  -- Log supply status
  logInfo(string.format("Supply updated: %d/%d minted (%d remaining)", 
    State.total_minted, MAX_SUPPLY, State.remaining_supply))
  
  return State.total_minted, State.remaining_supply
end

-- Record successful mint in history
local function recordMintSuccess(nftId, owner, timestamp)
  local mintRecord = {
    nft_id = nftId,
    owner = owner,
    minted_at = timestamp or getCurrentTimestamp(),
    block_height = nil, -- Could be set if available
    transaction_id = nil -- Will be set by caller if available
  }
  
  -- Add to mint history (we can use nft_ids array for this)
  if not table.contains(State.nft_ids, nftId) then
    table.insert(State.nft_ids, nftId)
  end
  
  logInfo(string.format("Mint success recorded: NFT #%d to %s at %s", 
    nftId, owner, mintRecord.minted_at))
  
  return mintRecord
end

-- Core Atomic Assets mint function
local function mintAtomicAsset(nftId, owner, metadata)
  -- Validate all inputs
  if not nftId or nftId <= 0 or nftId > MAX_SUPPLY then
    return false, "Invalid NFT ID"
  end
  
  if not isValidAddress(owner) then
    return false, "Invalid owner address"
  end
  
  if not metadata then
    return false, "Metadata required"
  end
  
  -- Validate metadata structure
  local validation = validateMetadata(metadata)
  if not validation.valid then
    logError("Invalid metadata for minting", {
      nft_id = nftId,
      errors = validation.errors
    })
    return false, "Invalid metadata structure"
  end
  
  -- Check if NFT already exists
  if State.nft_owners[nftId] then
    return false, "NFT already minted"
  end
  
  -- Set ownership
  local ownershipSet, ownershipError = setOwnership(nftId, owner)
  if not ownershipSet then
    return false, "Ownership setting failed: " .. ownershipError
  end
  
  -- Store metadata
  local metadataStored, metadataError = storeNFTMetadata(nftId, metadata)
  if not metadataStored then
    -- Rollback ownership if metadata storage fails
    State.nft_owners[nftId] = nil
    State.nft_balances[owner] = (State.nft_balances[owner] or 1) - 1
    return false, "Metadata storage failed: " .. metadataError
  end
  
  -- Update global supply counters
  State.total_minted = State.total_minted + 1
  updateSupply()
  
  -- Record mint success
  recordMintSuccess(nftId, owner, getCurrentTimestamp())
  
  logInfo(string.format("Atomic Asset minted: NFT #%d to %s", nftId, owner))
  
  return true, "NFT minted successfully"
end

-- Complete mint execution (integrating all previous functions)
local function executeFullMint(buyerAddress, paymentAmount)
  logInfo(string.format("Starting full mint execution for %s (Amount: %s)", buyerAddress, paymentAmount))
  
  -- Pre-validation
  local eligibility = checkMintEligibility(buyerAddress)
  if not eligibility.eligible then
    logError("Mint eligibility failed", {
      address = buyerAddress,
      reason = eligibility.reason
    })
    return createErrorResponse(eligibility.reason)
  end
  
  -- Generate NFT ID
  local nftId, idError = generateNFTId()
  if not nftId then
    logError("NFT ID generation failed", {error = idError})
    return createErrorResponse("NFT ID generation failed")
  end
  
  -- Generate NFT data (lucky number + market sentiment)
  local nftData, dataError = generateNFTData(nftId)
  if not nftData then
    logError("NFT data generation failed", {nft_id = nftId, error = dataError})
    return createErrorResponse("NFT data generation failed: " .. (dataError or "unknown error"))
  end
  
  -- Generate metadata
  local metadata, metadataError = generateNFTMetadata(nftId, buyerAddress, nftData.lucky_number, nftData.market_sentiment)
  if not metadata then
    logError("Metadata generation failed", {nft_id = nftId, error = metadataError})
    return createErrorResponse("Metadata generation failed: " .. (metadataError or "unknown error"))
  end
  
  -- Execute Atomic Assets mint
  local mintSuccess, mintError = mintAtomicAsset(nftId, buyerAddress, metadata)
  if not mintSuccess then
    logError("Atomic Assets mint failed", {nft_id = nftId, error = mintError})
    return createErrorResponse("NFT minting failed: " .. mintError)
  end
  
  -- Record additional data (lucky number and market sentiment are recorded by mintAtomicAsset via metadata)
  recordLuckyNumber(nftId, nftData.lucky_number)
  recordMarketSentiment(nftId, nftData.market_sentiment)
  
  -- Record revenue
  local revenueSuccess, revenueError = recordRevenue(nftId, paymentAmount)
  if not revenueSuccess then
    logError("Revenue recording failed", {nft_id = nftId, error = revenueError})
    -- Continue anyway as mint was successful
  end
  
  logInfo(string.format("Full mint execution completed: NFT #%d to %s", nftId, buyerAddress))
  
  return createSuccessResponse({
    nft_id = nftId,
    owner = buyerAddress,
    name = metadata.name,
    lucky_number = nftData.lucky_number,
    market_sentiment = nftData.market_sentiment,
    metadata = metadata,
    message = string.format("Successfully minted NFT #%d", nftId)
  })
end

-- Get mint status overview
local function getMintStatusOverview()
  local status = {
    basic_info = {
      name = NFT_NAME,
      symbol = NFT_SYMBOL,
      total_supply = MAX_SUPPLY,
      current_supply = State.total_minted,
      remaining_supply = getRemainingSupply()
    },
    mint_state = {
      status = State.total_minted >= MAX_SUPPLY and "sold_out" or "active",
      public_mint_enabled = checkPublicMintEnabled(),
      mint_enabled = State.mint_enabled
    },
    statistics = {
      minted_percentage = (State.total_minted / MAX_SUPPLY) * 100,
      unique_holders = 0,
      last_minted_id = nil
    }
  }
  
  -- Count unique holders
  local holders = {}
  for _, owner in pairs(State.nft_owners) do
    holders[owner] = true
  end
  for _ in pairs(holders) do
    status.statistics.unique_holders = status.statistics.unique_holders + 1
  end
  
  -- Get last minted NFT ID
  if #State.nft_ids > 0 then
    status.statistics.last_minted_id = State.nft_ids[#State.nft_ids]
  end
  
  return status
end

-- Get NFT information (Atomic Assets compliance)
local function getNFTInfo(nftId)
  if not nftId or nftId <= 0 or nftId > MAX_SUPPLY then
    return nil, "Invalid NFT ID"
  end
  
  local owner = State.nft_owners[nftId]
  if not owner then
    return nil, "NFT not found"
  end
  
  local metadata = State.nft_metadata[nftId]
  local luckyNumber = State.lucky_numbers_assigned[nftId]
  local marketSentiment = State.market_sentiments[nftId]
  
  local nftInfo = {
    nft_id = nftId,
    name = metadata and metadata.name or generateNFTName(nftId),
    owner = owner,
    minted = true,
    minted_at = metadata and metadata.minted_at,
    lucky_number = luckyNumber,
    market_sentiment = marketSentiment,
    metadata = metadata,
    
    -- Atomic Assets standard fields
    collection = {
      name = "BeliefFi DeFAI NFT Collection",
      family = "AO MAXI"
    },
    standard = "Atomic Assets",
    version = "1.0"
  }
  
  return nftInfo, nil
end

-- Get all NFTs owned by an address
local function getNFTsByOwner(ownerAddress)
  if not isValidAddress(ownerAddress) then
    return nil, "Invalid address"
  end
  
  local ownedNFTs = {}
  
  for nftId, owner in pairs(State.nft_owners) do
    if owner == ownerAddress then
      local nftInfo, error = getNFTInfo(nftId)
      if nftInfo then
        table.insert(ownedNFTs, nftInfo)
      end
    end
  end
  
  -- Sort by NFT ID
  table.sort(ownedNFTs, function(a, b) return a.nft_id < b.nft_id end)
  
  return {
    owner = ownerAddress,
    nfts_owned = #ownedNFTs,
    nfts = ownedNFTs
  }, nil
end

-- Basic transfer function (limited for future SBT conversion)
local function transferNFT(nftId, fromAddress, toAddress)
  -- Basic validation
  if not nftId or nftId <= 0 or nftId > MAX_SUPPLY then
    return false, "Invalid NFT ID"
  end
  
  if not isValidAddress(fromAddress) or not isValidAddress(toAddress) then
    return false, "Invalid address"
  end
  
  -- Check ownership
  local currentOwner = State.nft_owners[nftId]
  if currentOwner ~= fromAddress then
    return false, "Not the owner"
  end
  
  -- For MVP, we'll implement but log a warning about future SBT conversion
  logInfo("WARNING: Transfer executed - will be restricted when converted to SBT")
  
  -- Execute transfer
  State.nft_owners[nftId] = toAddress
  
  -- Update balances
  State.nft_balances[fromAddress] = (State.nft_balances[fromAddress] or 1) - 1
  initializeBalance(toAddress)
  State.nft_balances[toAddress] = (State.nft_balances[toAddress] or 0) + 1
  
  -- Update metadata owner
  if State.nft_metadata[nftId] then
    State.nft_metadata[nftId].owner = toAddress
  end
  
  logInfo(string.format("NFT #%d transferred from %s to %s", nftId, fromAddress, toAddress))
  
  return true, "Transfer successful"
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
  
  -- Initialize Lucky Numbers
  local luckyInit = initializeLuckyNumbers()
  if not luckyInit then
    logError("Failed to initialize Lucky Numbers")
    return false
  end
  
  -- Initialize Market Sentiment Patterns
  local sentimentInit = initializeSentimentPatterns()
  if not sentimentInit then
    logError("Failed to initialize Market Sentiment patterns")
    return false
  end
  
  -- Set initial process tags
  ao.id = ao.id or "PROCESS_ID_PLACEHOLDER"
  
  return true
end

-- Run initialization on process start
if not State.initialized then
  local success = initializeProcess()
  if success then
    State.initialized = true
    logInfo("Process initialization completed successfully")
  else
    logError("Process initialization failed")
  end
end

-- ============================================================================
-- MESSAGE HANDLERS (Phase 3-1)
-- ============================================================================

-- Credit-Notice Handler for USDA payments
Handlers.add("CreditNotice", Handlers.utils.hasMatchingTag("Action", "Credit-Notice"), function(msg)
  logInfo("Credit-Notice received from: " .. (msg.From or "unknown"))
  
  -- Validate the credit notice
  local isValid, paymentDetails = validateCreditNotice(msg)
  if not isValid then
    logError("Invalid Credit-Notice", {
      from = msg.From,
      action = msg.Action,
      error = paymentDetails
    })
    return -- Ignore invalid credit notices
  end
  
  logInfo("Processing payment from: " .. paymentDetails.from_address .. " Amount: " .. paymentDetails.amount)
  
  -- Process payment and mint
  local result = processPaymentAndMint(paymentDetails)
  
  -- Send response back to the payer
  if result.status == "success" then
    ao.send({
      Target = paymentDetails.from_address,
      Action = "Mint-Success",
      ["NFT-ID"] = tostring(result.data.nft_id),
      ["Lucky-Number"] = tostring(result.data.lucky_number),
      ["Market-Sentiment"] = result.data.market_sentiment.ao_sentiment,
      ["Confidence-Score"] = tostring(result.data.market_sentiment.confidence_score),
      ["Transaction-ID"] = paymentDetails.transaction_id,
      Data = json.encode(result.data)
    })
    
    logInfo("Mint success notification sent to: " .. paymentDetails.from_address)
  else
    ao.send({
      Target = paymentDetails.from_address,
      Action = "Mint-Error",
      ["Error-Message"] = result.message,
      ["Transaction-ID"] = paymentDetails.transaction_id,
      Data = json.encode(result)
    })
    
    logError("Mint error notification sent to: " .. paymentDetails.from_address .. " Error: " .. result.message)
  end
end)

-- ============================================================================
-- PHASE 5-1: BASIC HANDLERS IMPLEMENTATION
-- ============================================================================

-- Info Handler: Return basic process information
Handlers.add("Info", Handlers.utils.hasMatchingTag("Action", "Info"), function(msg)
  logInfo("Processing Info request")
  
  local info = {
    Name = NFT_NAME,
    Ticker = NFT_SYMBOL,
    Denomination = "1",
    Logo = "https://arweave.net/belieffi-logo", -- Fixed logo URL
    Description = "DeFAI NFT Collection - Believing in AO's growth",
    Total_Supply = tostring(MAX_SUPPLY),
    Current_Supply = tostring(State.total_minted),
    Mint_Price = "1 USDA",
    Mint_Status = State.total_minted >= MAX_SUPPLY and "sold_out" or "active",
    Mint_Type = "Public Mint",
    Contract_Type = "Atomic Asset - BeliefFi NFT"
  }
  
  logInfo("Info request processed successfully", {current_supply = State.total_minted})
  
  ao.send({
    Target = msg.From,
    Action = "Info-Response",
    Data = json.encode(info)
  })
end)

-- Balance Handler: Check balance by address
Handlers.add("Balance", Handlers.utils.hasMatchingTag("Action", "Balance"), function(msg)
  local target = msg.Tags.Target or msg.From
  
  logInfo("Processing Balance request", {target = target})
  
  if not isValidAddress(target) then
    logError("Invalid address format", {address = target})
    ao.send({
      Target = msg.From,
      Action = "Balance-Error",
      Error = "Invalid address format"
    })
    return
  end
  
  local balance = State.nft_balances[target] or 0
  
  logInfo("Balance request processed", {target = target, balance = balance})
  
  ao.send({
    Target = msg.From,
    Action = "Balance-Response",
    Balance = tostring(balance),
    Target = target
  })
end)

-- Balances Handler: List all address balances
Handlers.add("Balances", Handlers.utils.hasMatchingTag("Action", "Balances"), function(msg)
  logInfo("Processing Balances request")
  
  local balances = {}
  for address, balance in pairs(State.nft_balances) do
    if balance > 0 then
      balances[address] = tostring(balance)
    end
  end
  
  logInfo("Balances request processed", {total_holders = table.getn(balances)})
  
  ao.send({
    Target = msg.From,
    Action = "Balances-Response",
    Data = json.encode(balances)
  })
end)

-- Metadata Handler: Return NFT metadata
Handlers.add("Metadata", Handlers.utils.hasMatchingTag("Action", "Metadata"), function(msg)
  local nftId = tonumber(msg.Tags["NFT-ID"])
  
  logInfo("Processing Metadata request", {nft_id = nftId})
  
  if not nftId then
    logError("Invalid NFT ID format")
    ao.send({
      Target = msg.From,
      Action = "Metadata-Error",
      Error = "Invalid NFT ID format"
    })
    return
  end
  
  if nftId < 1 or nftId > MAX_SUPPLY then
    logError("NFT ID out of range", {nft_id = nftId})
    ao.send({
      Target = msg.From,
      Action = "Metadata-Error",
      Error = "NFT ID out of range"
    })
    return
  end
  
  local metadata = State.nft_metadata[nftId]
  if not metadata then
    logError("NFT not found", {nft_id = nftId})
    ao.send({
      Target = msg.From,
      Action = "Metadata-Error",
      Error = "NFT not found"
    })
    return
  end
  
  logInfo("Metadata request processed", {nft_id = nftId})
  
  ao.send({
    Target = msg.From,
    Action = "Metadata-Response",
    ["NFT-ID"] = tostring(nftId),
    Data = json.encode(metadata)
  })
end)

-- Helper function to get table length (Lua doesn't have built-in length for hash tables)
local function table.getn(t)
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end

-- ============================================================================
-- PHASE 5-2: MINT HANDLERS IMPLEMENTATION
-- ============================================================================

-- Mint-Eligibility Handler: Check if address can mint
Handlers.add("Mint-Eligibility", Handlers.utils.hasMatchingTag("Action", "Mint-Eligibility"), function(msg)
  local address = msg.Tags.Address or msg.From
  
  logInfo("Processing Mint-Eligibility request", {address = address})
  
  if not isValidAddress(address) then
    logError("Invalid address format", {address = address})
    ao.send({
      Target = msg.From,
      Action = "Mint-Eligibility-Error",
      Error = "Invalid address format"
    })
    return
  end
  
  local alreadyMinted = (State.mint_records[address] and State.mint_records[address].total_minted > 0)
  local soldOut = (State.total_minted >= MAX_SUPPLY)
  local mintEligible = not alreadyMinted and not soldOut
  
  local reason = ""
  if alreadyMinted then
    reason = "Address has already minted"
  elseif soldOut then
    reason = "Collection sold out"
  else
    reason = "Eligible for minting"
  end
  
  local eligibilityData = {
    address = address,
    already_minted = alreadyMinted,
    mint_eligible = mintEligible,
    reason = reason
  }
  
  logInfo("Mint-Eligibility request processed", {address = address, eligible = mintEligible})
  
  ao.send({
    Target = msg.From,
    Action = "Mint-Eligibility-Response",
    Data = json.encode({
      status = "success",
      data = eligibilityData
    })
  })
end)

-- Transfer Handler: NFT transfer processing (with SBT restrictions)
Handlers.add("Transfer", Handlers.utils.hasMatchingTag("Action", "Transfer"), function(msg)
  local recipient = msg.Tags.Recipient
  local nftId = tonumber(msg.Tags["NFT-ID"])
  local sender = msg.From
  
  logInfo("Processing Transfer request", {sender = sender, recipient = recipient, nft_id = nftId})
  
  -- Validate input parameters
  if not recipient or not nftId then
    logError("Missing required parameters", {recipient = recipient, nft_id = nftId})
    ao.send({
      Target = msg.From,
      Action = "Transfer-Error",
      Error = "Missing required parameters: Recipient and NFT-ID"
    })
    return
  end
  
  if not isValidAddress(recipient) then
    logError("Invalid recipient address", {recipient = recipient})
    ao.send({
      Target = msg.From,
      Action = "Transfer-Error",
      Error = "Invalid recipient address format"
    })
    return
  end
  
  -- Check NFT ownership
  local nftOwner = State.nft_owners[nftId]
  if not nftOwner or nftOwner ~= sender then
    logError("Sender does not own NFT", {sender = sender, nft_id = nftId, actual_owner = nftOwner})
    ao.send({
      Target = msg.From,
      Action = "Transfer-Error",
      Error = "You do not own this NFT"
    })
    return
  end
  
  -- SBT Restriction Warning (for future implementation)
  logInfo("WARNING: Transfer executed - future SBT conversion will restrict transfers", {nft_id = nftId})
  
  -- Execute transfer
  local transferResult = transferNFT(nftId, sender, recipient)
  if not transferResult.success then
    logError("Transfer execution failed", {error = transferResult.message})
    ao.send({
      Target = msg.From,
      Action = "Transfer-Error",
      Error = transferResult.message
    })
    return
  end
  
  logInfo("Transfer completed successfully", {sender = sender, recipient = recipient, nft_id = nftId})
  
  -- Notify sender
  ao.send({
    Target = msg.From,
    Action = "Transfer-Response",
    Data = json.encode({
      status = "success",
      data = {
        nft_id = nftId,
        from = sender,
        to = recipient,
        timestamp = getCurrentTimestamp()
      }
    })
  })
  
  -- Notify recipient
  ao.send({
    Target = recipient,
    Action = "Transfer-Notice",
    Data = json.encode({
      message = "NFT received",
      nft_id = nftId,
      from = sender,
      timestamp = getCurrentTimestamp()
    })
  })
end)

-- Mint-Status Handler: Current mint status information
Handlers.add("Mint-Status", Handlers.utils.hasMatchingTag("Action", "Mint-Status"), function(msg)
  local address = msg.Tags.Address
  
  logInfo("Processing Mint-Status request", {address = address})
  
  local statusData = {
    total_supply = MAX_SUPPLY,
    current_supply = State.total_minted,
    remaining = MAX_SUPPLY - State.total_minted,
    mint_price = "1 USDA",
    status = State.total_minted >= MAX_SUPPLY and "sold_out" or "active"
  }
  
  -- Add address-specific eligibility if address provided
  if address then
    if not isValidAddress(address) then
      logError("Invalid address format for status check", {address = address})
      ao.send({
        Target = msg.From,
        Action = "Mint-Status-Error",
        Error = "Invalid address format"
      })
      return
    end
    
    local alreadyMinted = (State.mint_records[address] and State.mint_records[address].total_minted > 0)
    statusData.address_eligible = not alreadyMinted and statusData.status == "active"
  end
  
  logInfo("Mint-Status request processed", {current_supply = State.total_minted, status = statusData.status})
  
  ao.send({
    Target = msg.From,
    Action = "Mint-Status-Response",
    Data = json.encode({
      status = "success",
      data = statusData
    })
  })
end)

-- ============================================================================
-- PHASE 6: BASIC ERROR HANDLING IMPLEMENTATION
-- ============================================================================

-- Error Types (for classification)
local ERROR_TYPES = {
  INPUT = "INPUT",
  BUSINESS = "BUSINESS", 
  SYSTEM = "SYSTEM"
}

-- Unified error handler
local function handleError(errorMessage, errorType, additionalData)
  errorType = errorType or ERROR_TYPES.SYSTEM
  additionalData = additionalData or {}
  
  local errorData = {
    message = errorMessage,
    type = errorType,
    timestamp = getCurrentTimestamp(),
    data = additionalData
  }
  
  logError("Error handled", errorData)
  
  return {
    status = "error",
    message = errorMessage
  }
end

-- Send error response to user
local function sendError(msg, errorMessage, errorType, additionalData)
  local errorResponse = handleError(errorMessage, errorType, additionalData)
  
  ao.send({
    Target = msg.From,
    Action = msg.Tags.Action and (msg.Tags.Action .. "-Error") or "Error",
    Data = json.encode(errorResponse)
  })
  
  return errorResponse
end

-- Enhanced input validation with error handling
local function validateInput(value, validationType, fieldName)
  fieldName = fieldName or "field"
  
  if validationType == "address" then
    if not value or not isValidAddress(value) then
      return false, "Invalid " .. fieldName .. " format"
    end
  elseif validationType == "nft_id" then
    local nftId = tonumber(value)
    if not nftId or nftId < 1 or nftId > MAX_SUPPLY then
      return false, "Invalid " .. fieldName
    end
  elseif validationType == "payment_amount" then
    local amount = tonumber(value)
    if not amount or amount ~= MINT_PRICE then
      return false, "Invalid payment amount"
    end
  elseif validationType == "required" then
    if not value or value == "" then
      return false, fieldName .. " is required"
    end
  end
  
  return true, nil
end

-- Business rule validation
local function validateBusinessRules(address, operation)
  if operation == "mint" then
    -- Check if already minted
    if State.mint_records[address] and State.mint_records[address].total_minted > 0 then
      return false, "Address already minted"
    end
    
    -- Check if sold out
    if State.total_minted >= MAX_SUPPLY then
      return false, "All NFTs sold out"
    end
  end
  
  return true, nil
end

-- Simplified rollback processing
local function rollbackMint(nftId, ownerAddress, paymentAmount, reason)
  logInfo("Initiating mint rollback", {
    nft_id = nftId,
    owner = ownerAddress,
    amount = paymentAmount,
    reason = reason
  })
  
  -- Reset NFT ownership if set
  if nftId and State.nft_owners[nftId] then
    State.nft_owners[nftId] = nil
    logInfo("NFT ownership reset", {nft_id = nftId})
  end
  
  -- Reset balance if updated
  if ownerAddress and State.nft_balances[ownerAddress] then
    if State.nft_balances[ownerAddress] > 0 then
      State.nft_balances[ownerAddress] = State.nft_balances[ownerAddress] - 1
      logInfo("Balance rollback completed", {address = ownerAddress})
    end
  end
  
  -- Reset supply count if updated
  if State.total_minted > 0 then
    State.total_minted = State.total_minted - 1
    logInfo("Supply count rollback completed", {new_total = State.total_minted})
  end
  
  -- Process refund
  if ownerAddress and paymentAmount then
    local refundResult = processRefund(ownerAddress, paymentAmount)
    if not refundResult.success then
      logError("Rollback refund failed", {
        address = ownerAddress,
        amount = paymentAmount,
        error = refundResult.message
      })
      return false, "Rollback refund failed"
    else
      logInfo("Rollback refund completed", {address = ownerAddress, amount = paymentAmount})
    end
  end
  
  logInfo("Mint rollback completed successfully")
  return true, "Rollback completed"
end

-- Safe execution wrapper
local function safeExecute(operation, ...)
  local success, result = pcall(operation, ...)
  
  if not success then
    local errorMsg = "System error: " .. tostring(result)
    logError("Safe execution failed", {error = result})
    return {
      success = false,
      message = errorMsg,
      type = ERROR_TYPES.SYSTEM
    }
  end
  
  return result
end

-- Error recovery mechanism
local function attemptRecovery(errorType, errorData)
  logInfo("Attempting error recovery", {type = errorType, data = errorData})
  
  if errorType == ERROR_TYPES.BUSINESS then
    -- For business errors, no automatic recovery
    return false, "No automatic recovery for business rule violations"
  elseif errorType == ERROR_TYPES.SYSTEM then
    -- For system errors, attempt basic state validation
    if not State.total_minted then
      State.total_minted = 0
      logInfo("Reset total_minted counter")
    end
    if not State.mint_records then
      State.mint_records = {}
      logInfo("Reset mint_records")
    end
    return true, "Basic state recovery attempted"
  end
  
  return false, "No recovery mechanism for this error type"
end

-- Error reporting for debugging
local function getErrorSummary()
  local summary = {
    total_minted = State.total_minted,
    remaining_supply = MAX_SUPPLY - State.total_minted,
    total_addresses = 0,
    total_revenue = State.total_revenue or 0,
    timestamp = getCurrentTimestamp()
  }
  
  -- Count unique addresses
  for address, _ in pairs(State.mint_records or {}) do
    summary.total_addresses = summary.total_addresses + 1
  end
  
  return summary
end

-- ============================================================================
-- PHASE 7: SIMPLE TESTING IMPLEMENTATION
-- ============================================================================

-- Test environment flag (set to false for production)
local TEST_MODE = true

-- Basic function test: Process information verification
local function testBasicInfo()
  if not TEST_MODE then
    logError("Test functions disabled in production mode")
    return false, "Test mode disabled"
  end
  
  logInfo("=== Testing Basic Info ===")
  
  local info = {
    Name = NFT_NAME,
    Ticker = NFT_SYMBOL,
    Denomination = "1",
    Total_Supply = tostring(MAX_SUPPLY),
    Current_Supply = tostring(State.total_minted),
    Mint_Price = "1 USDA",
    Mint_Status = State.total_minted >= MAX_SUPPLY and "sold_out" or "active",
    Mint_Type = "Public Mint",
    Contract_Type = "Atomic Asset - BeliefFi NFT"
  }
  
  logInfo("Basic Info Test Results", info)
  logInfo("=== Basic Info Test Completed ===")
  
  return true, info
end

-- Mint flow test with test address
local function testMintFlow(testAddress)
  if not TEST_MODE then
    logError("Test functions disabled in production mode")
    return false, "Test mode disabled"
  end
  
  testAddress = testAddress or "test_address_123456789012345678901234567890123456789012"
  
  logInfo("=== Testing Mint Flow ===", {test_address = testAddress})
  
  -- Test input validation
  local addressValid, addressError = validateInput(testAddress, "address", "test address")
  logInfo("Address validation result", {valid = addressValid, error = addressError})
  
  -- Test business rules
  local rulesValid, rulesError = validateBusinessRules(testAddress, "mint")
  logInfo("Business rules validation result", {valid = rulesValid, error = rulesError})
  
  -- Test lucky number generation
  local luckyNumber = getNextLuckyNumber()
  logInfo("Lucky number generated", {lucky_number = luckyNumber})
  
  -- Test market sentiment
  local sentiment = generateMarketSentiment(luckyNumber)
  logInfo("Market sentiment generated", sentiment)
  
  -- Test NFT ID generation
  local nftId = generateNFTId()
  logInfo("NFT ID generated", {nft_id = nftId})
  
  -- Test metadata generation
  local metadata = generateNFTMetadata(nftId, testAddress, luckyNumber)
  logInfo("Metadata generated", {nft_id = nftId, metadata_preview = {
    name = metadata.name,
    lucky_number = metadata.lucky_number,
    market_sentiment = metadata.market_sentiment.ao_sentiment
  }})
  
  logInfo("=== Mint Flow Test Completed ===")
  
  return true, {
    address = testAddress,
    nft_id = nftId,
    lucky_number = luckyNumber,
    sentiment = sentiment.ao_sentiment,
    metadata = metadata
  }
end

-- Test limitation functions
local function testLimitations()
  if not TEST_MODE then
    logError("Test functions disabled in production mode")
    return false, "Test mode disabled"
  end
  
  logInfo("=== Testing Limitations ===")
  
  -- Test supply limits
  local supplyInfo = {
    max_supply = MAX_SUPPLY,
    current_supply = State.total_minted,
    remaining = MAX_SUPPLY - State.total_minted,
    is_sold_out = State.total_minted >= MAX_SUPPLY
  }
  logInfo("Supply limitation test", supplyInfo)
  
  -- Test address limitation (mock multiple addresses)
  local testAddresses = {
    "addr1_123456789012345678901234567890123456789012",
    "addr2_123456789012345678901234567890123456789012",
    "addr3_123456789012345678901234567890123456789012"
  }
  
  for i, addr in ipairs(testAddresses) do
    local alreadyMinted = (State.mint_records[addr] and State.mint_records[addr].total_minted > 0)
    logInfo("Address limitation test", {
      address = addr,
      already_minted = alreadyMinted,
      can_mint = not alreadyMinted and not supplyInfo.is_sold_out
    })
  end
  
  logInfo("=== Limitations Test Completed ===")
  
  return true, supplyInfo
end

-- Debug function: Output current state
local function debugState()
  if not TEST_MODE then
    logError("Debug functions disabled in production mode")
    return false, "Test mode disabled"
  end
  
  logInfo("=== Debug State ===")
  
  local stateInfo = {
    total_minted = State.total_minted,
    remaining_supply = MAX_SUPPLY - State.total_minted,
    mint_records_count = 0,
    nft_owners_count = 0,
    nft_balances_count = 0,
    total_revenue = State.total_revenue or 0,
    processed_transactions_count = 0
  }
  
  -- Count records
  for _ in pairs(State.mint_records or {}) do
    stateInfo.mint_records_count = stateInfo.mint_records_count + 1
  end
  
  for _ in pairs(State.nft_owners or {}) do
    stateInfo.nft_owners_count = stateInfo.nft_owners_count + 1
  end
  
  for _ in pairs(State.nft_balances or {}) do
    stateInfo.nft_balances_count = stateInfo.nft_balances_count + 1
  end
  
  for _ in pairs(State.processed_transactions or {}) do
    stateInfo.processed_transactions_count = stateInfo.processed_transactions_count + 1
  end
  
  logInfo("Current State Information", stateInfo)
  logInfo("=== Debug State Completed ===")
  
  return stateInfo
end

-- Debug function: Output mint status
local function debugMintStatus()
  if not TEST_MODE then
    logError("Debug functions disabled in production mode")
    return false, "Test mode disabled"
  end
  
  logInfo("=== Debug Mint Status ===")
  
  local mintStatus = {
    is_minting_active = isMintingActive(),
    total_supply = MAX_SUPPLY,
    current_supply = State.total_minted,
    remaining = getRemainingSupply(),
    mint_price = MINT_PRICE,
    mint_price_usda = "1 USDA",
    lucky_numbers_used = State.lucky_number_used_count or 0,
    sentiment_stats = getMarketSentimentStats()
  }
  
  logInfo("Mint Status Information", mintStatus)
  logInfo("=== Debug Mint Status Completed ===")
  
  return mintStatus
end

-- Test reset function (development only)
local function resetForTesting()
  if not TEST_MODE then
    logError("Reset functions disabled in production mode")
    return false, "Test mode disabled"
  end
  
  logInfo("=== Resetting State for Testing ===")
  logInfo("WARNING: This will reset all data - use only in development!")
  
  -- Reset all state variables
  State.total_minted = 0
  State.mint_records = {}
  State.nft_owners = {}
  State.nft_balances = {}
  State.nft_metadata = {}
  State.payment_records = {}
  State.processed_transactions = {}
  State.total_revenue = 0
  State.revenue_records = {}
  State.process_balance = 0
  State.lucky_number_index = 0
  State.lucky_number_used_count = 0
  State.market_sentiment_records = {}
  
  logInfo("State reset completed for testing")
  logInfo("=== Reset Completed ===")
  
  return true, "Reset completed"
end

-- Run all tests
local function runAllTests()
  if not TEST_MODE then
    logError("Test functions disabled in production mode")
    return false, "Test mode disabled"
  end
  
  logInfo("=== Running All Tests ===")
  
  local results = {}
  
  -- Run basic info test
  local infoSuccess, infoResult = testBasicInfo()
  results.basicInfo = {success = infoSuccess, result = infoResult}
  
  -- Run mint flow test
  local flowSuccess, flowResult = testMintFlow()
  results.mintFlow = {success = flowSuccess, result = flowResult}
  
  -- Run limitations test
  local limitSuccess, limitResult = testLimitations()
  results.limitations = {success = limitSuccess, result = limitResult}
  
  -- Debug state
  local stateResult = debugState()
  results.debugState = stateResult
  
  -- Debug mint status
  local statusResult = debugMintStatus()
  results.debugMintStatus = statusResult
  
  logInfo("=== All Tests Completed ===", {
    basicInfo = results.basicInfo.success,
    mintFlow = results.mintFlow.success,
    limitations = results.limitations.success
  })
  
  return results
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
  
  -- Mint Limitation functions (Phase 1-3)
  checkMintEligibility = checkMintEligibility,
  recordMint = recordMint,
  getMintStatusDetailed = getMintStatusDetailed,
  validateMintRequestDetailed = validateMintRequestDetailed,
  getMintHistory = getMintHistory,
  checkSupplyLimits = checkSupplyLimits,
  
  -- Lucky Number functions (Phase 2-1)
  initializeLuckyNumbers = initializeLuckyNumbers,
  getNextLuckyNumber = getNextLuckyNumber,
  recordLuckyNumber = recordLuckyNumber,
  getLuckyNumberForNFT = getLuckyNumberForNFT,
  getLuckyNumberStats = getLuckyNumberStats,
  previewNextLuckyNumber = previewNextLuckyNumber,
  
  -- Market Sentiment functions (Phase 2-2)
  initializeSentimentPatterns = initializeSentimentPatterns,
  getSentimentByLuckyNumber = getSentimentByLuckyNumber,
  generateMarketSentiment = generateMarketSentiment,
  formatSentimentData = formatSentimentData,
  recordMarketSentiment = recordMarketSentiment,
  getMarketSentimentForNFT = getMarketSentimentForNFT,
  getMarketSentimentStats = getMarketSentimentStats,
  generateNFTData = generateNFTData,
  
  -- Payment Processing functions (Phase 3-1)
  validatePaymentAmount = validatePaymentAmount,
  isTransactionProcessed = isTransactionProcessed,
  recordPayment = recordPayment,
  processRefund = processRefund,
  getPaymentStatus = getPaymentStatus,
  validateCreditNotice = validateCreditNotice,
  processPaymentAndMint = processPaymentAndMint,
  getPaymentStats = getPaymentStats,
  
  -- Fund Management functions (Phase 3-2)
  recordRevenue = recordRevenue,
  getProcessBalance = getProcessBalance,
  processRefundEnhanced = processRefundEnhanced,
  getRevenueReport = getRevenueReport,
  getFundManagementStatus = getFundManagementStatus,
  
  -- NFT Metadata Management functions (Phase 4-1)
  formatNumberWithZeroPad = formatNumberWithZeroPad,
  generateNFTName = generateNFTName,
  generateExternalURL = generateExternalURL,
  validateMetadata = validateMetadata,
  generateNFTMetadata = generateNFTMetadata,
  getSentimentRarityTier = getSentimentRarityTier,
  storeNFTMetadata = storeNFTMetadata,
  getMetadata = getMetadata,
  updateMetadata = updateMetadata,
  getMetadataStats = getMetadataStats,
  regenerateAllMetadata = regenerateAllMetadata,
  
  -- Mint Execution functions (Phase 4-2)
  generateNFTId = generateNFTId,
  setOwnership = setOwnership,
  updateSupply = updateSupply,
  recordMintSuccess = recordMintSuccess,
  mintAtomicAsset = mintAtomicAsset,
  executeFullMint = executeFullMint,
  getNFTInfo = getNFTInfo,
  getNFTsByOwner = getNFTsByOwner,
  transferNFT = transferNFT,
  
  -- Error Handling functions (Phase 6)
  handleError = handleError,
  sendError = sendError,
  validateInput = validateInput,
  validateBusinessRules = validateBusinessRules,
  rollbackMint = rollbackMint,
  safeExecute = safeExecute,
  attemptRecovery = attemptRecovery,
  getErrorSummary = getErrorSummary,
  
  -- Testing functions (Phase 7)
  testBasicInfo = testBasicInfo,
  testMintFlow = testMintFlow,
  testLimitations = testLimitations,
  debugState = debugState,
  debugMintStatus = debugMintStatus,
  resetForTesting = resetForTesting,
  runAllTests = runAllTests,
  
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