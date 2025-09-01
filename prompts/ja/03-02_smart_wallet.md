Phase 3-1 の成果物を基に、Smart Wallet 連携機能を実装します。

要件:

- Smart Wallet の自動作成・紐付け機能
- Mint 収益の転送処理（一時預かり →Smart Wallet）
- NFT-Wallet 関係の管理
- 1:1 紐付けの保証

実装内容:

1. Smart Wallet Process の自動作成（aos.spawn 使用）
2. NFT ID と Wallet ID の紐付け記録
3. 一時預かり資金の Smart Wallet への転送
4. 紐付け関係の検証・管理

技術仕様:

- 1 NFT = 1 Smart Wallet
- 作成タイミング: Mint 成功直後
- 転送方法: ao.send()による Transfer
- Ownership: 運営が保持（NFT 保有者には移転しない）

処理フロー:

1. Mint 成功確認
2. Smart Wallet Process 作成（aos.spawn）
3. NFT-Wallet 紐付け記録
4. 1 USDA 転送実行（一時預かり →Smart Wallet）
5. 転送結果記録

データ構造:

- nft_to_wallet: NFT ID → Smart Wallet Process ID
- wallet_transfers: 転送記録
- temporary_balance: 一時預かり残高

機能要件:

1. createSmartWallet(nft_id, owner_address): Smart Wallet 作成
2. transferToSmartWallet(nft_id, amount): 収益転送
3. recordWalletBinding(nft_id, wallet_id): 紐付け記録
4. getWalletByNFT(nft_id): Wallet ID 取得

Smart Wallet 作成設定:

- Module: 基本 AO モジュール使用
- Scheduler: デフォルト Scheduler
- Tags: ["Type"] = "Smart-Wallet", ["NFT-ID"] = nft_id
- 初期残高: 0

エラーハンドリング:

- Smart Wallet 作成失敗: "Smart Wallet creation failed"
- 転送失敗: "Transfer to Smart Wallet failed"
- 重複作成防止: 既存 Wallet ID チェック

巻き戻し処理:

- レベル 2: Mint 後、Smart Wallet 作成前 → Mint 成功、USDA 一時保管
- レベル 3: Smart Wallet 作成後、転送失敗 → ログ記録、手動対応

前回のコードに統合し、Smart Wallet 連携を含む完全なコードで実装してください。
