Phase 1-2 の成果物を基に、Mint 制限管理機能を実装します。

要件:

- 1 アドレス 1 個制限の厳格な実装
- Mint 済みアドレス追跡システム
- 制限チェック機能
- Mint 可能性の事前検証

実装内容:

1. Mint 済みアドレスの記録・管理システム
2. アドレス毎の Mint 制限チェック機能
3. Mint 可能数の計算機能（最大 100 個）
4. 制限違反時のエラー処理

データ構造:

- minted_by_address: アドレス別 Mint 記録（boolean 値）
- total_minted: 総 Mint 数（0-100）
- remaining_mints: 残り Mint 可能数（100-total_minted）

機能要件:

1. checkMintEligibility(address): Mint 可否判定
2. recordMint(address): Mint 記録の保存
3. getMintStatus(): Mint 状況の取得
4. validateMintRequest(address): Mint 要求の事前検証

制限ロジック（Public Mint 版）:

- **Allow List チェックなし（誰でも Mint 可能）**
- 既に Mint 済みのアドレスは拒否（1 アドレス 1 個まで）
- 発行上限 100 個に達している場合は拒否
- 1 回の Mint で必ず 1 個のみ

前回のコードに追加し、統合された完全なコードで提供してください。
