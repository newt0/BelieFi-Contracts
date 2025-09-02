--[[
  ApusAI Library for BelieFi NFT Process
  Beta version for AO Hackathon
  
  This is a simplified implementation of the ApusAI SDK
  for demonstration purposes during the hackathon.
]]--

local json = require("json")
local ao = require("ao")

-- ApusAI Process ID (placeholder - will be provided by Apus team)
local APUS_AI_PROCESS_ID = "APUS_AI_INFERENCE_PROCESS_ID_PLACEHOLDER"
local APUS_TOKEN_PROCESS_ID = "APUS_TOKEN_PROCESS_ID_PLACEHOLDER"

-- Module table
local ApusAI = {}

-- Internal state for tracking requests
local _requests = {}
local _requestCounter = 0
local _networkEnabled = false

-- Generate unique request ID
local function generateRequestId()
  _requestCounter = _requestCounter + 1
  return "apus_req_" .. tostring(_requestCounter) .. "_" .. tostring(os.time())
end

-- Default options for inference
local DEFAULT_OPTIONS = {
  max_tokens = 200,
  temp = 0.7,
  top_p = 0.95,
  system_prompt = "You are a helpful AI assistant."
}

-- Merge options with defaults
local function mergeOptions(options)
  local merged = {}
  for k, v in pairs(DEFAULT_OPTIONS) do
    merged[k] = v
  end
  if options then
    for k, v in pairs(options) do
      merged[k] = v
    end
  end
  return merged
end

-- Format error object
local function formatError(code, message)
  return {
    code = code or "UNKNOWN_ERROR",
    message = message or "An unknown error occurred"
  }
end

-- Format success response
local function formatResponse(data, session, attestation, reference)
  return {
    data = data,
    session = session or generateRequestId(),
    attestation = attestation or "simulated-attestation",
    reference = reference
  }
end

-- Configure process IDs
function ApusAI.configure(opts)
  if type(opts) ~= "table" then return end
  if type(opts.ai_process_id) == "string" then APUS_AI_PROCESS_ID = opts.ai_process_id end
  if type(opts.token_process_id) == "string" then APUS_TOKEN_PROCESS_ID = opts.token_process_id end
end

-- Enable/disable network mode
function ApusAI.enableNetwork(flag)
  _networkEnabled = not not flag
end

-- Internal: send inference message to APUS AI process
local function sendInferenceMessage(prompt, options, reference)
  local tags = {
    Action = "Inference-Request",
    Reference = reference,
    Session = options.session or generateRequestId(),
    MaxTokens = tostring(options.max_tokens or DEFAULT_OPTIONS.max_tokens),
    Temperature = tostring(options.temp or DEFAULT_OPTIONS.temp),
    TopP = tostring(options.top_p or DEFAULT_OPTIONS.top_p)
  }
  local msg = {
    Target = APUS_AI_PROCESS_ID,
    Tags = tags,
    Data = prompt
  }
  if ao and ao.send then ao.send(msg) end
end

-- Optional: pay for an inference task via token process
function ApusAI.sendPayment(amount, reference)
  local qty = tostring(amount)
  local msg = {
    Target = APUS_TOKEN_PROCESS_ID,
    Tags = {
      Action = "Transfer",
      Recipient = APUS_AI_PROCESS_ID,
      Quantity = qty,
      Reference = reference
    },
    Data = ""
  }
  if ao and ao.send then ao.send(msg) end
end

--[[
  Main inference function
  @param prompt string - The prompt to send to the AI
  @param options table - Optional configuration (max_tokens, temp, top_p, system_prompt, session, reference)
  @param callback function - Optional callback function(err, res)
  @return string - Task reference ID
]]
function ApusAI.infer(prompt, options, callback)
  -- Handle different parameter combinations
  if type(options) == "function" then
    callback = options
    options = {}
  end
  
  options = mergeOptions(options)
  
  -- Generate reference if not provided
  local reference = options.reference or generateRequestId()
  
  -- Store request for tracking
  _requests[reference] = {
    prompt = prompt,
    options = options,
    callback = callback,
    status = "pending",
    timestamp = os.time()
  }
  
  -- Network path: send to APUS if enabled and configured
  if _networkEnabled and APUS_AI_PROCESS_ID ~= "APUS_AI_INFERENCE_PROCESS_ID_PLACEHOLDER" and ao and ao.send then
    _requests[reference].status = "sent"
    sendInferenceMessage(prompt, options, reference)
    return reference
  end

  -- For hackathon MVP: Simulate AI response analyzing $AO price data
  -- In production, this would send actual request to APUS_AI_PROCESS_ID
  local simulateResponse = function()
    -- Simulate processing delay
    local request = _requests[reference]
    if not request then return end
    
    -- Parse prompt to determine response type
    local response
    local err = nil
    
    if string.find(prompt:lower(), "market sentiment") or string.find(prompt:lower(), "$ao") then
      -- Extract price data from prompt (matching actual prompt format)
      local price = tonumber(string.match(prompt, "Current Price: %$([%d%.]+)")) or 1.0
      local volume = tonumber(string.match(prompt, "24h Trading Volume: %$([%d%.]+)")) or 100000
      local priceChange = tonumber(string.match(prompt, "24h Price Change: ([%+%-]?[%d%.]+)%%")) or 0
      
      -- Determine sentiment based on $AO price metrics
      local sentiment
      local confidence
      
      -- Price change is the primary factor
      if priceChange > 10 then
        sentiment = "very_bullish"
        confidence = 0.85 + (math.min(priceChange, 30) / 100)
      elseif priceChange > 3 then
        sentiment = "bullish"
        confidence = 0.70 + (priceChange / 50)
      elseif priceChange < -10 then
        sentiment = "bearish"
        confidence = 0.75 + (math.min(math.abs(priceChange), 20) / 100)
      elseif priceChange < -3 then
        sentiment = "bearish"
        confidence = 0.65 + (math.abs(priceChange) / 50)
      else
        sentiment = "neutral"
        confidence = 0.60 + (volume / 10000000) -- Volume adds confidence
      end
      
      -- Adjust confidence based on volume (higher volume = more confidence)
      if volume > 1000000 then
        confidence = math.min(0.95, confidence + 0.1)
      elseif volume > 500000 then
        confidence = math.min(0.95, confidence + 0.05)
      end
      
      -- Market factors based on price analysis
      local factors = {
        bearish = {"price_downtrend", "low_volume", "selling_pressure"},
        neutral = {"sideways_movement", "consolidation", "uncertain_direction"},
        bullish = {"price_uptrend", "strong_volume", "buying_pressure"},
        very_bullish = {"breakout_momentum", "high_volume", "strong_accumulation"}
      }
      
      -- Create a copy of factors to avoid mutating the original
      local selectedFactors = {}
      local baseFactor = factors[sentiment] or factors.neutral
      for _, factor in ipairs(baseFactor) do
        table.insert(selectedFactors, factor)
      end
      
      -- Add specific factors based on metrics
      if volume > 1000000 then
        table.insert(selectedFactors, "high_trading_activity")
      end
      if math.abs(priceChange) > 15 then
        table.insert(selectedFactors, "significant_price_movement")
      end
      
      response = formatResponse(
        json.encode({
          ao_sentiment = sentiment,
          confidence_score = confidence,
          market_factors = selectedFactors
        }),
        options.session,
        "gpu-attestation-" .. reference,
        reference
      )
    else
      -- Generic response
      response = formatResponse(
        "AI response for: " .. string.sub(prompt, 1, 50),
        options.session,
        "gpu-attestation-" .. reference,
        reference
      )
    end
    
    -- Update request status
    request.status = "completed"
    request.response = response
    request.error = err
    
    -- Call callback if provided
    if callback then
      callback(err, response)
    else
      -- Print to console if no callback
      if err then
        print("[ApusAI Error] " .. err.message)
      else
        print("[ApusAI Response] " .. response.data)
      end
    end
  end
  
  -- In MVP, simulate immediate response
  -- In production, this would be handled by message handlers
  simulateResponse()
  
  return reference
end

--[[
  Get service information
  @param callback function - Callback function(err, info)
]]
function ApusAI.getInfo(callback)
  if not callback then
    error("Callback is required for getInfo")
  end
  
  -- For hackathon MVP: Return simulated info
  -- Count only pending tasks
  local pendingCount = 0
  for _, request in pairs(_requests) do
    if request.status == "pending" then
      pendingCount = pendingCount + 1
    end
  end
  
  local info = {
    price = 100, -- Price in Armstrongs
    worker_count = 4,
    pending_tasks = pendingCount,
    available = true
  }
  
  callback(nil, info)
end

--[[
  Get task status
  @param taskRef string - The task reference ID
  @param callback function - Callback function(err, status)
]]
function ApusAI.getTaskStatus(taskRef, callback)
  if not callback then
    error("Callback is required for getTaskStatus")
  end
  
  local request = _requests[taskRef]
  if not request then
    callback(formatError("NOT_FOUND", "Task not found"), nil)
    return
  end
  
  local status = {
    reference = taskRef,
    status = request.status,
    prompt = request.prompt,
    timestamp = request.timestamp
  }
  
  if request.status == "completed" then
    status.response = request.response
    status.error = request.error
  end
  
  callback(nil, status)
end

--[[
  Initialize handlers for real APUS integration
  This would be called when actually connecting to APUS network
]]
function ApusAI.initHandlers()
  -- Check if Handlers is available (provided by AO runtime)
  if not Handlers then
    print("[ApusAI] Warning: Handlers not available, skipping handler initialization")
    return false
  end
  
  -- Handler for inference acknowledgements (e.g., queued/processing)
  Handlers.add(
    "apus-inference-ack",
    Handlers.utils.hasMatchingTag("Action", "Inference-Ack"),
    function(msg)
      local reference = msg.Tags.Reference
      local request = _requests[reference]
      if not request then return end
      local phase = msg.Tags.Phase or "queued"
      request.status = phase
    end
  )

  -- Handler for inference responses
  Handlers.add(
    "apus-inference-response",
    Handlers.utils.hasMatchingTag("Action", "Inference-Response"),
    function(msg)
      local reference = msg.Tags.Reference
      local request = _requests[reference]
      
      if not request then
        return
      end
      
      local success = msg.Tags.Status == "Success"
      
      if success then
        local response = formatResponse(
          msg.Data,
          msg.Tags.Session,
          msg.Tags.Attestation,
          reference
        )
        
        request.status = "completed"
        request.response = response
        
        if request.callback then
          request.callback(nil, response)
        end
      else
        local err = formatError(
          msg.Tags.ErrorCode or "INFERENCE_FAILED",
          msg.Tags.ErrorMessage or msg.Data
        )
        
        request.status = "failed"
        request.error = err
        
        if request.callback then
          request.callback(err, nil)
        end
      end
    end
  )
  
  -- Handler for payment confirmations
  Handlers.add(
    "apus-payment-confirmation",
    Handlers.utils.hasMatchingTag("Action", "Payment-Confirmation"),
    function(msg)
      -- Handle payment confirmation for inference requests
      print("[ApusAI] Payment confirmed: " .. (msg.Tags.Amount or "unknown"))
    end
  )
  
  print("[ApusAI] Handlers initialized successfully")
  return true
end

-- Export module
return ApusAI
