Phase 5-1 の成果物を基に、Mint 関連 Handler 群を実装します。

要件:

- Mint 実行 Handler（Credit-Notice 統合）
- Allow List 確認 Handler
- Transfer Handler（将来の SBT 対応）
- Mint 状態管理 Handler

実装内容:

1. Credit-Notice Handler: 支払い受信・Mint 実行
2. Allow-List Handler: アドレス許可状況確認
3. Transfer Handler: NFT 転送処理（制限付き）
4. Mint-Status Handler: Mint 可能性確認

Handler 仕様:

### Credit-Notice Handler

Action: "Credit-Notice"
トリガー: USDA トークンからの転送受信時
処理フロー:

1. 送信者検証（USDA のみ受付）
2. 支払い金額検証（exactly 1000000000000）
3. Allow List・制限チェック
4. 完全 Mint 実行
5. 結果通知

### Allow-List Handler

Action: "Allow-List"
Tags: Address = 確認対象アドレス
返却データ:
{
address: 対象アドレス,
allowed: true|false,
already_minted: true|false,
mint_eligible: true|false,
reason: 理由説明
}

### Transfer Handler

Action: "Transfer"  
Tags: Recipient = 転送先, NFT-ID = NFT 識別子
制約: SBT 化対応で制限付き実装
返却: 転送結果（成功・失敗・制限理由）

### Mint-Status Handler

Action: "Mint-Status"
Tags: Address = 対象アドレス（オプション）
返却データ:
{
total_supply: 100,
current_supply: 現在発行数,
remaining: 残り発行可能数,
mint_price: "1 USDA",
status: "active"|"sold_out",
address_eligible: アドレス指定時の適格性
}

機能要件:

1. 非同期処理の適切な管理
2. Transaction ID 重複防止
3. 原子性の保証（部分実行の防止）
4. 詳細なログ記録

Credit-Notice 処理詳細:

1. msg.From == USDT Token ID 検証
2. msg.Tags["Action"] == "Credit-Notice" 確認
3. 支払い者アドレス取得（From-Process or Sender）
4. executeFullMint()呼び出し
5. 結果を Sender に通知

エラーハンドリング:

- 無効な送信者: 処理せずに無視
- 支払い不足/超過: 適切な返金処理
- Mint 失敗: 全額返金 + エラー通知
- システムエラー: 詳細ログ + 手動対応フラグ

レスポンス統一:

- 成功: {status: "success", data: 結果データ}
- 失敗: {status: "error", message: エラー詳細}

前回のコードに統合し、完全な Handler 群を含むコードで実装してください。

MVP に向けた推奨修正は全て受け入れいます。

1. Phase 3-2 簡素化: Smart
   Wallet 作成を後回しにして、一時的にプロセス内で資金管理
2. Phase 6 簡素化: 基本的なエラーハンドリングのみ実装
3. Phase 7 削除: 単体テストをシンプルな動作確認に置き換え

また、Allow List は要件から外して、Public Mint にした方が実装がラクですか？
