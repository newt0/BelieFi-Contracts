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
  
  -- For hackathon MVP: Simulate AI response with deterministic output
  -- In production, this would send actual request to APUS_AI_PROCESS_ID
  local simulateResponse = function()
    -- Simulate processing delay
    local request = _requests[reference]
    if not request then return end
    
    -- Parse prompt to determine response type
    local response
    local err = nil
    
    if string.find(prompt:lower(), "market sentiment") or string.find(prompt:lower(), "ao token") then
      -- Generate market sentiment response
      local luckyFactor = tonumber(string.match(prompt, "(%d+)")) or 500
      local sentiment
      
      if luckyFactor >= 700 then
        sentiment = "very_bullish"
      elseif luckyFactor >= 400 then
        sentiment = "bullish"
      elseif luckyFactor >= 200 then
        sentiment = "neutral"
      else
        sentiment = "bearish"
      end
      
      local confidenceBase = 0.6
      local confidenceVariation = (luckyFactor % 100) / 100 * 0.3
      local confidence = math.min(0.95, confidenceBase + confidenceVariation)
      
      local factors = {
        bearish = {"regulatory_concerns", "market_volatility", "institutional_uncertainty"},
        neutral = {"market_uncertainty", "mixed_signals", "consolidation_phase"},
        bullish = {"institutional_adoption", "developer_activity", "ecosystem_expansion"},
        very_bullish = {"ecosystem_growth", "token_utility", "mass_adoption"}
      }
      
      response = formatResponse(
        json.encode({
          ao_sentiment = sentiment,
          confidence_score = confidence,
          market_factors = factors[sentiment] or factors.neutral
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
  local info = {
    price = 100, -- Price in Armstrongs
    worker_count = 4,
    pending_tasks = #_requests,
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
end

-- Export module
return ApusAI