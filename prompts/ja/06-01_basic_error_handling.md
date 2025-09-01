Phase 5 の成果物を基に、基本的なエラーハンドリングシステムを実装します（MVP 簡素版）。

要件:

- 基本的なエラー処理機能
- シンプルなエラーメッセージ
- 必要最小限のロールバック
- 基本的なログ記録

実装内容:

1. 基本的なエラーキャッチ
2. エラーメッセージの返却
3. 簡単なロールバック処理
4. コンソールログ出力

エラー分類（簡素版）:

### 入力エラー
- "Invalid address format"
- "Invalid payment amount"
- "Invalid NFT ID"

### ビジネスエラー
- "Address already minted"
- "All NFTs sold out"
- "Insufficient payment"

### システムエラー
- "Mint failed"
- "Refund failed"
- "System error"

統一エラーレスポンス（簡素版）:
{
status: "error",
message: エラーメッセージ
}

機能要件:

1. handleError(error_message): 基本エラー処理
2. sendError(msg, error_message): エラーレスポンス送信
3. logError(error_message): コンソールログ出力

ロールバック（簡素版）:

- 支払い失敗時: 全額返金
- Mint 失敗時: 状態リセット + 返金

MVP 簡素化ポイント:

- 複雑なエラー分類なし
- 詳細なログシステムなし
- 自動リトライなし
- 手動対応キューなし

前回のコードに統合し、基本的なエラーハンドリングを含む完全なコードで実装してください。