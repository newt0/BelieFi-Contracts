# BelieFi 実装プロンプト一覧（MVP 版）

## 概要

本ディレクトリには、BelieFi DeFAI NFT プロジェクトの Atomic Assets AO Process を段階的に実装するためのプロンプトが含まれています。ハッカソン向け MVP として、Public Mint 方式で簡素化された実装となっています。

## 技術仕様

- プラットフォーム: AO (Arweave L2)
- NFT 規格: Atomic Assets
- 決済通貨: AstroUSD (USDA) - 1 USDA/NFT
- 発行上限: 100 個
- 制限: 1 アドレス 1 個まで
- **Mint 方式: Public Mint（Allow List なし）**

## MVP 簡素化ポイント

- ✅ Public Mint 方式（誰でも Mint 可能）
- ✅ Smart Wallet 作成なし（資金はプロセス内管理）
- ✅ 基本的なエラーハンドリングのみ
- ✅ シンプルな動作確認（自動テストなし）

## プロンプト実行順序

### Phase 1: 基盤実装

| ファイル                    | 依存関係 | 説明                                    |
| --------------------------- | -------- | --------------------------------------- |
| `01-01_basic_structure.md`  | なし     | AO Process 基本構造・State 初期化       |
| `01-02_public_mint.md`      | 01-01    | Public Mint 基本機能                    |
| `01-03_mint_limitations.md` | 01-02    | 1 アドレス 1 個制限・供給量管理         |

### Phase 2: 外部連携実装

| ファイル                    | 依存関係 | 説明                                    |
| --------------------------- | -------- | --------------------------------------- |
| `02-01_lucky_number.md`     | 01-03    | Lucky Number 生成（ハードコード版）     |
| `02-02_market_sentiment.md` | 02-01    | Market Sentiment 生成（ハードコード版） |

### Phase 3: 決済・資金管理

| ファイル                      | 依存関係 | 説明                        |
| ----------------------------- | -------- | --------------------------- |
| `03-01_payment_processing.md` | 02-02    | USDA 決済処理・検証システム |
| `03-02_fund_management.md`    | 03-01    | プロセス内資金管理          |

### Phase 4: NFT Core 機能

| ファイル                       | 依存関係 | 説明                               |
| ------------------------------ | -------- | ---------------------------------- |
| `04-01_metadata_management.md` | 03-02    | NFT メタデータ生成・管理           |
| `04-02_mint_execution.md`      | 04-01    | 完全 Mint 実行・Atomic Assets 準拠 |

### Phase 5: Handler 実装

| ファイル                  | 依存関係 | 説明                                             |
| ------------------------- | -------- | ------------------------------------------------ |
| `05-01_basic_handlers.md` | 04-02    | Info・Balance・Metadata Handler                  |
| `05-02_mint_handlers.md`  | 05-01    | Credit-Notice・Mint-Eligibility・Transfer Handler |

### Phase 6: エラーハンドリング・動作確認

| ファイル                         | 依存関係 | 説明                           |
| -------------------------------- | -------- | ------------------------------ |
| `06-01_basic_error_handling.md` | 05-02    | 基本的なエラー処理             |
| `07-01_simple_test.md`          | 06-01    | シンプルな動作確認・デバッグ   |

## 実行方法

1. 各フェーズを順番に実行（依存関係を守る）
2. 前のタスクの成果物を次のタスクに引き継ぐ
3. 各プロンプトは独立して実行可能
4. エラー発生時は前のフェーズから再実行

## 最終成果物

- Public Mint 方式の Atomic Assets AO Process
- 誰でも Mint 可能（1 アドレス 1 個制限）
- USDA 決済・プロセス内資金管理
- 基本的なエラーハンドリング
- MVP として動作可能な品質

## 注意事項

- RandAO・Apus Network 統合は後日実装予定（現在はハードコード）
- Smart Wallet 機能は MVP 後に実装予定
- Bot 対策は必要に応じて後日追加
- NFT は将来的に SBT（譲渡制限付き）として実装予定