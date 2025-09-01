Phase 6-1 の成果物を基に、データ検証・セキュリティ検証システムを実装します。

要件:

- 入力データの包括的バリデーション
- 状態整合性チェック機能
- セキュリティ検証システム
- データ整合性保証機能

実装内容:

1. 入力バリデーション機能
2. 状態整合性チェック
3. セキュリティ検証機能
4. 定期的整合性監査

バリデーション機能:

### アドレス検証

1. validateAddress(address): AO Address 形式チェック
2. 文字列長さ検証（43 文字固定）
3. 使用可能文字チェック（Base64URL）
4. 構造整合性確認

### 金額検証

1. validateAmount(amount): 数値形式・範囲チェック
2. 最小値・最大値制限
3. 精度チェック（整数のみ）
4. オーバーフロー防止

### NFT ID 検証

1. validateNFTId(nft_id): ID 形式・範囲チェック
2. 数値範囲（1-100）
3. 存在チェック
4. 重複防止

### メタデータ検証

1. validateMetadata(metadata): 構造・内容チェック
2. 必須フィールド存在確認
3. データ型整合性
4. 値域チェック

状態整合性チェック:

### Supply 整合性

1. checkSupplyConsistency(): 発行数整合性
2. total_minted vs 実際の NFT 数
3. remaining_supply 計算検証
4. 上限値チェック

### Balance 整合性

1. checkBalanceConsistency(): 残高整合性
2. 個別残高 vs 総残高
3. NFT 所有者 vs Balance 記録
4. 重複所有防止

### 支払い整合性

1. checkPaymentConsistency(): 支払い記録整合性
2. 受金額 vs 発行 NFT 数
3. 返金記録整合性
4. Smart Wallet 残高整合性

セキュリティ検証:

### アクセス制御

1. validateSender(msg): 送信者検証
2. Authority 確認
3. Permission check
4. Rate limiting（簡易実装）

### Transaction 検証

1. validateTransaction(msg): Transaction 整合性
2. 重複 Transaction 防止
3. Timestamp 検証
4. Signature 確認（AO 標準）

### 状態変更検証

1. validateStateChange(): 状態変更妥当性
2. 不正な状態遷移防止
3. 原子性保証
4. 競合状態回避

定期監査機能:

1. performIntegrityAudit(): 定期整合性チェック
2. generateAuditReport(): 監査レポート生成
3. detectAnomalies(): 異常検出
4. autoCorrection(): 自動修正（安全な範囲のみ）

検証結果構造:
{
valid: true|false,
validation_details: {
address_valid: boolean,
amount_valid: boolean,
state_consistent: boolean,
security_passed: boolean
},
errors: エラー詳細配列,
warnings: 警告詳細配列
}

前回のコードに統合し、完全な検証システムを含むコードで実装してください。
