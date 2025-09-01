Phase 4 の成果物を基に、基本 Handler 群を実装します。

要件:

- Atomic Assets 標準準拠の Handler 実装
- プロセス情報取得機能
- 残高・メタデータ取得機能
- エラーハンドリングの統一

実装内容:

1. Info Handler: プロセス基本情報の返却
2. Balance Handler: アドレス別残高確認
3. Balances Handler: 全アドレス残高一覧
4. Metadata Handler: NFT メタデータ返却

Handler 仕様:

### Info Handler

Action: "Info"
返却データ:
{
Name: "AO MAXI",
Ticker: "AOMAXI",
Denomination: "1",
Logo: "固定ロゴ URL",
Description: "DeFAI NFT Collection - AO の成長を信じる",
Total_Supply: "100",
Current_Supply: 現在の発行済み数,
Mint_Price: "1 USDA",
Mint_Status: "active"|"sold_out",
Mint_Type: "Public Mint",
Contract_Type: "Atomic Asset - BeliefFi NFT"
}

### Balance Handler

Action: "Balance"
Tags: Target = 対象アドレス
返却: アドレスの NFT 保有数

### Balances Handler

Action: "Balances"
返却: 全アドレスの残高マップ

### Metadata Handler

Action: "Metadata"
Tags: NFT-ID = NFT 識別子
返却: 指定 NFT の完全メタデータ

機能要件:

1. 標準レスポンス形式の統一
2. エラー時の適切なメッセージ返却
3. 存在しないデータへの対応
4. パフォーマンス最適化

エラーレスポンス:

- NFT 不存在: "NFT not found"
- アドレス無効: "Invalid address format"
- データ取得失敗: "Failed to retrieve data"

前回のコードに追加し、基本 Handler 群を含む完全なコードで実装してください。
