# RandAO Integration Test Guide for AO Process

## 前提条件
- AOSクライアントがインストール済み
- USDA（AstroUSD）トークンを保有しているウォレット
- RandAO用の支払いトークン（RNG）を保有（または初回はモックテスト）

## 1. Processのデプロイ

### Step 1: AOSを起動
```bash
aos
```

### Step 2: Processをロード
```lua
.load contracts/beliefi-nft-process.lua
```

### Step 3: 依存関係を確認
```lua
-- random.luaモジュールもロード
.load contracts/random.lua
```

## 2. RandAO設定の確認

### 初期状態確認
```lua
-- RandAOが有効か確認
Send({ Target = ao.id, Action = "Get-Pending-Mints" })
```

期待される応答:
```json
{
  "status": "success",
  "pending_mints": [],
  "randao_enabled": true,
  "timeout_threshold": 30000
}
```

## 3. テストシナリオ

### テスト1: RandAO無効状態でのミント（ハードコード使用）

```lua
-- RandAOを無効化
Send({ 
  Target = ao.id, 
  Action = "Toggle-RandAO",
  Tags = { Enable = "false" }
})

-- ミント適格性確認
Send({ 
  Target = ao.id, 
  Action = "Mint-Eligibility" 
})

-- USDA支払いをシミュレート（Credit-Notice）
Send({
  Target = ao.id,
  Action = "Credit-Notice",
  From = "FBt9A5GA_KXMMSxA2DJ0xZbAq8sLLU2ak-YJe9zDvg8", -- USDA Process ID
  Quantity = "1000000000000",
  Sender = ao.id
})
```

期待される結果:
- 即座にMint-Successメッセージ受信
- ハードコードされたラッキーナンバー割り当て

### テスト2: RandAO有効状態でのミント

```lua
-- RandAOを有効化
Send({ 
  Target = ao.id, 
  Action = "Toggle-RandAO",
  Tags = { Enable = "true" }
})

-- USDA支払いをシミュレート
Send({
  Target = ao.id,
  Action = "Credit-Notice",
  From = "FBt9A5GA_KXMMSxA2DJ0xZbAq8sLLU2ak-YJe9zDvg8",
  Quantity = "1000000000000",
  Sender = ao.id
})

-- 保留中のミントを確認
Send({ 
  Target = ao.id, 
  Action = "Get-Pending-Mints" 
})
```

期待される結果:
- Mint-Pendingステータス
- pending_mintsリストにエントリ追加

### テスト3: RandAOレスポンスのシミュレート

```lua
-- モックRandom-Responseを送信
-- 注: 実際のテストではRandAOプロセスから送信される
Send({
  Target = ao.id,
  Action = "Random-Response",
  From = "kuvKD4kpIZ-GY4MxSFhOUWIyVl3Oe8a7JDvBT8LsrbI", -- RandAO Process ID
  Data = json.encode({
    callbackId = "取得したcallback_id",
    entropy = "123456789"
  })
})
```

期待される結果:
- Mint-Successメッセージ受信
- ランダムなラッキーナンバー（entropy % 1000）
- 適切なマーケットセンチメント

### テスト4: タイムアウトフォールバック

```lua
-- 30秒待機後、タイムアウトチェック
Send({ 
  Target = ao.id, 
  Action = "Check-Pending-Mints" 
})
```

期待される結果:
- タイムアウトしたミントが自動的にフォールバック
- Mint-Success-Timeoutメッセージ受信

## 4. 統合テストスクリプト

```lua
-- 完全な統合テストフロー
local function runIntegrationTest()
  print("=== RandAO Integration Test ===")
  
  -- Step 1: 初期状態確認
  Send({ Target = ao.id, Action = "Info" })
  Inbox[#Inbox].Data -- 確認
  
  -- Step 2: RandAO有効化
  Send({ 
    Target = ao.id, 
    Action = "Toggle-RandAO",
    Tags = { Enable = "true" }
  })
  
  -- Step 3: ミント試行
  print("Attempting mint with RandAO...")
  -- ここで実際のUSDトークン転送またはCredit-Noticeシミュレート
  
  -- Step 4: 保留確認
  Send({ Target = ao.id, Action = "Get-Pending-Mints" })
  local pending = json.decode(Inbox[#Inbox].Data)
  print("Pending mints: " .. #pending.pending_mints)
  
  -- Step 5: RandAOレスポンス待機またはタイムアウト
  -- 実際の環境では自動的に処理される
  
  print("Test completed!")
end

-- テスト実行
runIntegrationTest()
```

## 5. トラブルシューティング

### よくある問題と解決方法

1. **RandAOプロセスに接続できない**
   - RandAO DNS設定を確認: `randomModule.updateConfig()`
   - 支払いトークン残高を確認

2. **タイムアウトが発生しない**
   - `State.randao_fallback_timeout`値を確認（デフォルト30秒）
   - `Check-Pending-Mints`を手動実行

3. **ラッキーナンバーが生成されない**
   - `State.current_lucky_index`を確認
   - ハードコードされた配列の範囲確認

## 6. 本番デプロイ前チェックリスト

- [ ] RandAO支払いトークン（RNG）の残高確認
- [ ] `State.randao_enabled = true`に設定
- [ ] タイムアウト値が適切（30秒推奨）
- [ ] エラーログ機能が有効
- [ ] フォールバックメカニズムのテスト完了

## 7. モニタリングコマンド

```lua
-- 現在の状態確認
Send({ Target = ao.id, Action = "Info" })

-- 保留中のミント確認
Send({ Target = ao.id, Action = "Get-Pending-Mints" })

-- ミント統計確認
Send({ Target = ao.id, Action = "Mint-Status" })

-- RandAO設定確認
print("RandAO Enabled: " .. tostring(State.randao_enabled))
print("Timeout: " .. State.randao_fallback_timeout .. "ms")
```

## 注意事項

1. **テスト環境**: 最初はRandAOを無効にしてテスト
2. **本番環境**: 十分なRNG残高を確保してからRandAOを有効化
3. **監視**: 定期的に`Get-Pending-Mints`でスタックしたミントがないか確認