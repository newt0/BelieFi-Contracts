Phase 5 の成果物を基に、包括的エラーハンドリングシステムを実装します。

要件:

- 統一されたエラー処理フレームワーク
- エラーメッセージの標準化
- 失敗時のロールバック処理
- エラーログ記録システム

実装内容:

1. エラー分類・定義システム
2. 統一エラーレスポンス形式
3. ロールバック機能の実装
4. エラーログ記録・管理

エラー分類体系:

### システムエラー (ERROR_SYSTEM_xxx)

- ERROR_SYSTEM_INIT: "System initialization failed"
- ERROR_SYSTEM_STATE: "Invalid system state"
- ERROR_SYSTEM_STORAGE: "Data storage failed"
- ERROR_SYSTEM_EXTERNAL: "External service unavailable"

### バリデーションエラー (ERROR_VALIDATION_xxx)

- ERROR_VALIDATION_ADDRESS: "Invalid address format"
- ERROR_VALIDATION_AMOUNT: "Invalid payment amount"
- ERROR_VALIDATION_NFT_ID: "Invalid NFT ID"
- ERROR_VALIDATION_METADATA: "Invalid metadata structure"

### ビジネスロジックエラー (ERROR_BUSINESS_xxx)

- ERROR_BUSINESS_NOT_ALLOWED: "Address not in allow list"
- ERROR_BUSINESS_ALREADY_MINTED: "Address already minted NFT"
- ERROR_BUSINESS_SOLD_OUT: "All NFTs have been minted"
- ERROR_BUSINESS_INSUFFICIENT_PAYMENT: "Payment amount insufficient"
- ERROR_BUSINESS_OVERPAYMENT: "Payment amount exceeds required"

### プロセス実行エラー (ERROR_PROCESS_xxx)

- ERROR_PROCESS_MINT_FAILED: "NFT minting process failed"
- ERROR_PROCESS_WALLET_CREATION: "Smart Wallet creation failed"
- ERROR_PROCESS_TRANSFER_FAILED: "Token transfer failed"
- ERROR_PROCESS_REFUND_FAILED: "Refund process failed"

統一エラーレスポンス構造:
{
status: "error",
error_code: エラーコード,
error_message: 人間可読メッセージ,
error_details: 詳細情報,
timestamp: エラー発生時刻,
transaction_id: 関連 Transaction ID,
recovery_action: 復旧アクション（optional）
}

機能要件:

1. handleError(error_code, details, context): 統一エラー処理
2. logError(error_info): エラーログ記録
3. createErrorResponse(error_code, message): レスポンス生成
4. getRecoveryAction(error_code): 復旧アクション決定

ロールバック機能:

### Phase 1: 支払い検証段階

- 失敗時: 即座に全額返金
- 対象: バリデーション失敗、ビジネスルール違反

### Phase 2: Mint 実行段階

- 失敗時: 全額返金 + 状態リセット
- 対象: NFT 作成失敗、メタデータ生成失敗

### Phase 3: Smart Wallet 段階

- 失敗時: Mint 完了、資金一時保管
- 対象: Smart Wallet 作成失敗、転送失敗
- 復旧: 手動対応 + リトライ機能

### Phase 4: 転送完了段階

- 失敗時: ログ記録のみ
- 対象: 通知失敗、記録更新失敗

エラーログ構造:

- error_logs: エラー発生履歴
- recovery_queue: 手動対応待ちキュー
- failed_transactions: 失敗 Transaction 記録

前回のコードに統合し、包括的エラーハンドリングを含む完全なコードで実装してください。
