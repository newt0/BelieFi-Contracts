Phase 2 の成果物を基に、支払い処理システムを実装します。

要件:

- AstroUSD (USDA)決済処理（1 USDA 固定）
- 決済検証機能
- 支払い失敗時の処理
- トークン転送の受信・検証

実装内容:

1. Credit-Notice Handler による支払い受信処理
2. 支払い金額の検証（1 USDA exactly = 1000000000000 units）
3. 支払い元アドレスの検証
4. 不足・超過支払い時の処理

技術仕様:

- 決済トークン: AstroUSD (USDA)
- Token Process ID: "FBt9A5GA_KXMMSxA2DJ0xZbAq8sLLU2ak-YJe9zDvg8"
- 必要金額: "1000000000000" (1 USDA)
- 超過支払い: 返金処理
- 不足支払い: エラー返却
- タイムアウト: 設定なし（無期限待機）

データ構造:

- payment_records: 支払い記録
- processed_transactions: 処理済み Transaction ID
- pending_refunds: 返金待ちリスト

Handler 実装:

1. Credit-Notice Handler: msg.From == USDA Token ID の場合のみ処理
2. Transaction ID 重複チェック機能
3. 支払い金額検証（exactly 1000000000000）
4. Mint 制限チェック（Public Mint 対応）
5. 超過分返金機能

エラーハンドリング:

- 金額不足: "Insufficient payment. Required: 1 USDA"
- 金額超過: 差額返金 + "Overpayment refunded"
- 既 Mint 済み: "Address already minted"
- 売り切れ: "Sold out - 100 NFTs already minted"
- 重複処理: "Transaction already processed"

巻き戻し処理:

- レベル 1: 支払い受信後、Mint 前のエラー → 全額返金

MVP 簡素化:

- Allow List チェックなし（Public Mint）
- 基本的なエラーハンドリングのみ
- シンプルな返金処理

前回のコードに追加し、支払い処理を含む完全なコードで実装してください。
