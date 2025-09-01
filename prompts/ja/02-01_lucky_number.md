Phase 1 の成果物を基に、Lucky Number 生成機能をハードコードで実装します。

要件:

- ハードコードされた lucky_number 生成
- 0-999 の範囲での値
- Mint 時の自動割り当て
- 後の RandAO 統合への置き換え準備

実装内容:

1. 事前定義された lucky_number リストの作成
2. Mint 順序に基づく lucky_number 割り当て
3. NFT メタデータへの lucky_number 統合

ハードコード仕様:

- lucky_number 配列: {42, 777, 123, 888, 256, 369, 555, 999, 111, 666, ...}
- 100 個の NFT に対応する 100 個の lucky_number 値
- Mint 順序で配列から順次取得

データ構造:

- LUCKY_NUMBERS: 事前定義済みの配列（100 個の値）
- current_lucky_index: 次に使用する lucky_number のインデックス

機能要件:

1. initializeLuckyNumbers(): lucky_number 配列の初期化
2. getNextLuckyNumber(): 次の lucky_number 取得
3. recordLuckyNumber(mint_id, lucky_number): 記録保存

実装例:
LUCKY_NUMBERS = {42, 777, 123, 888, 256, 369, 555, 999, 111, 666, 234, 789, 456, 321, 654, ...}

コメント:
-- TODO: 将来 RandAO 統合時にこの部分を置き換え
-- ハードコード制約あり

前回のコードに追加し、lucky_number 生成を含む完全なコードで実装してください。
