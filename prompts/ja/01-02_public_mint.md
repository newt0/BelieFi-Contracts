Phase 1-1 の成果物を基に、Public Mint 機能を実装します。

要件:

- Public Mint の基本実装（Allow List なし）
- 誰でも Mint 可能
- シンプルな検証ロジック
- MVP 向け最小限の機能

実装内容:

1. Public Mint の有効化フラグ
2. Mint 可能性の簡易チェック機能
3. アドレス形式の基本検証のみ

データ構造:

- PUBLIC_MINT_ENABLED: true（常に有効）
- mint_enabled: グローバル Mint 可否フラグ

機能要件:

1. checkPublicMintEnabled(): Public Mint 有効確認
2. validateMintRequest(address): Mint 要求の基本検証
3. canMint(address): アドレスが Mint 可能か確認

制約:

- 最大 100 個の NFT
- 1 アドレス 1 個のみ Mint 可能
- Allow List チェックなし

エラーハンドリング:

- 不正なアドレス形式の処理
- Mint 無効時の処理

前回のコードに追加する形で実装してください。