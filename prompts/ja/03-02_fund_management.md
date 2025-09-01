Phase 3-1 の成果物を基に、資金管理機能を実装します（MVP 簡素版）。

要件:

- Smart Wallet 作成なし（MVP 簡素化）
- プロセス内での資金管理
- Mint 収益の記録・管理
- シンプルな残高管理

実装内容:

1. プロセス内での資金保管
2. Mint 収益の記録
3. 残高管理機能
4. 返金処理の実装

技術仕様:

- 資金保管: プロセス内で一時管理
- 収益記録: Mint ごとに記録
- 返金: 直接送金処理

処理フロー:

1. Mint 成功確認
2. 収益記録の更新
3. プロセス内残高の更新
4. 成功通知

データ構造:

- total_revenue: 総収益額
- revenue_records: Mint ごとの収益記録
- process_balance: プロセス内残高

機能要件:

1. recordRevenue(nft_id, amount): 収益記録
2. getProcessBalance(): 残高取得
3. processRefund(address, amount): 返金処理
4. getRevenueReport(): 収益レポート

MVP 簡素化ポイント:

- Smart Wallet 作成処理を削除
- aos.spawn() 不要
- 複雑な資金転送ロジックなし
- プロセス内で全資金を管理

エラーハンドリング:

- 返金失敗: "Refund failed"
- 残高不足: "Insufficient balance"

前回のコードに統合し、簡素化された資金管理を含む完全なコードで実装してください。