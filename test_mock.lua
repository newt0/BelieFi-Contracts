-- Test Mock for BeliefFi NFT Process
-- This file provides mock AO environment for local testing

-- Mock AO libraries
local json = require("json")

-- Mock ao object
ao = {
  id = "test_process_id_123456789012345678901234567890123456789012",
  send = function(msg)
    print("=== AO SEND ===")
    print("Target:", msg.Target)
    print("Action:", msg.Action)
    if msg.Data then
      print("Data:", msg.Data)
    end
    for k, v in pairs(msg.Tags or {}) do
      print("Tag " .. k .. ":", v)
    end
    print("===============")
  end
}

-- Mock Handlers
Handlers = {
  add = function(name, matcher, handler)
    print("Handler registered:", name)
    -- Store handler for testing
    if not _G.TestHandlers then
      _G.TestHandlers = {}
    end
    _G.TestHandlers[name] = {
      matcher = matcher,
      handler = handler
    }
  end,
  utils = {
    hasMatchingTag = function(tagName, tagValue)
      return function(msg)
        return msg.Tags and msg.Tags[tagName] == tagValue
      end
    end
  }
}

-- Mock Send function for testing
Send = function(msg)
  print("=== SEND MESSAGE ===")
  print("Target:", msg.Target)
  print("Action:", msg.Action)
  for k, v in pairs(msg.Tags or {}) do
    print("Tag " .. k .. ":", v)
  end
  print("===================")
  
  -- Try to find and execute matching handler
  if _G.TestHandlers then
    for name, handlerInfo in pairs(_G.TestHandlers) do
      if handlerInfo.matcher(msg) then
        print("Executing handler:", name)
        handlerInfo.handler(msg)
        break
      end
    end
  end
end

-- Load the main contract
dofile("contracts/belieffi-nft-process.lua")

-- Test execution
print("=== BeliefFi NFT Process Test Environment ===")
print("Available test functions:")
print("- testBasicInfo()")
print("- testMintFlow()")
print("- testLimitations()")
print("- debugState()")
print("- debugMintStatus()")
print("- runAllTests()")
print("=====================================")

-- Auto-run basic tests
print("\n=== Auto-running basic tests ===")
runAllTests()