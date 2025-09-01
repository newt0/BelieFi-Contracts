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