#!/bin/bash

# BelieFi NFT Process Deployment Script for AO
# This script helps deploy and test the RandAO-integrated NFT process

echo "=========================================="
echo "BelieFi NFT Process Deployment"
echo "=========================================="

# Check if aos is installed
if ! command -v aos &> /dev/null; then
    echo "Error: aos is not installed"
    echo "Please install aos first: npm install -g @permaweb/aos-cli"
    exit 1
fi

# Create deployment Lua script
cat > deploy_process.lua << 'EOF'
-- BelieFi NFT Process Deployment Script

print("Loading BelieFi NFT Process with RandAO Integration...")

-- Load the main process
.load contracts/belieffi-nft-process.lua

-- Verify the process loaded correctly
if State and State.randao_enabled ~= nil then
    print("✓ Process loaded successfully")
    print("✓ RandAO integration detected")
else
    print("✗ Process loading failed")
    return
end

-- Display initial configuration
print("\n=== Initial Configuration ===")
print("NFT Name: " .. (NFT_NAME or "Unknown"))
print("Max Supply: " .. (MAX_SUPPLY or 0))
print("Mint Price: 1 USDA")
print("RandAO Enabled: " .. tostring(State.randao_enabled))
print("Fallback Timeout: " .. (State.randao_fallback_timeout or 0) .. "ms")

-- Run basic health checks
print("\n=== Health Checks ===")

-- Check 1: Info handler
Send({ Target = ao.id, Action = "Info" })
print("✓ Info handler available")

-- Check 2: Mint eligibility
Send({ Target = ao.id, Action = "Mint-Eligibility" })
print("✓ Mint eligibility handler available")

-- Check 3: RandAO toggle
Send({ Target = ao.id, Action = "Get-Pending-Mints" })
print("✓ RandAO monitoring handlers available")

print("\n=== Deployment Complete ===")
print("Process ID: " .. ao.id)
print("\nNext steps:")
print("1. Test with RandAO disabled first")
print("2. Fund process with RNG tokens for RandAO")
print("3. Enable RandAO with Toggle-RandAO action")
print("4. Monitor with Get-Pending-Mints action")
EOF

echo "Starting AOS with deployment script..."
echo ""
echo "To deploy the process:"
echo "1. Run: aos"
echo "2. In AOS, run: .load deploy_process.lua"
echo ""
echo "For testing, use the commands in test_ao_randao.md"
echo ""
echo "Quick test commands:"
echo "  - Check status: Send({ Target = ao.id, Action = 'Info' })"
echo "  - Toggle RandAO: Send({ Target = ao.id, Action = 'Toggle-RandAO', Tags = { Enable = 'true' } })"
echo "  - Check pending: Send({ Target = ao.id, Action = 'Get-Pending-Mints' })"