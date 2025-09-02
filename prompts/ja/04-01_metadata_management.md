Phase 3 の成果物を基に、NFT メタデータ管理機能を実装します。

要件:

- 完全な NFT メタデータ構造の実装
- 動的メタデータ生成（lucky_number、market_sentiment 統合）
- メタデータ検証機能
- Atomic Assets 準拠のデータ構造

実装内容:

1. NFT メタデータの完全な構造定義
2. 動的メタデータ生成機能
3. メタデータ検証・バリデーション
4. メタデータ取得・更新機能

技術仕様:
NFT メタデータ構造:
{
name: "AO MAXI #[001-100]",
description: "AO の成長を信じる",
strategy: "$AO を最大化する",
image: "固定画像 URL",
external_url: "https://beliefi.arweave.net/nft/[nft_id]",
lucky_number: 0-999 の数値,
market_sentiment: {
ao_sentiment: "bullish"|"bearish"|"neutral"|"very_bullish",
confidence_score: 0.0-1.0,
analysis_timestamp: ISO8601 文字列,
market_factors: 文字列配列,
sentiment_source: "Powered by Apus Network"
},
attributes: [
{trait_type: "Lucky Number", value: lucky_number},
{trait_type: "Market Sentiment", value: ao_sentiment},
{trait_type: "Confidence Score", value: confidence_score},
{trait_type: "Strategy", value: "AO MAXI"}
]
}

データ構造:

- nft_metadata: NFT ID 別メタデータ保存
- metadata_templates: メタデータテンプレート
- validation_rules: バリデーションルール

機能要件:

1. generateNFTMetadata(nft_id, owner, lucky_number): メタデータ生成
2. validateMetadata(metadata): メタデータ検証
3. updateMetadata(nft_id, updates): メタデータ更新
4. getMetadata(nft_id): メタデータ取得
5. formatNumberWithZeroPad(number, digits): ゼロパディング

メタデータ生成ロジック:

1. ベースメタデータ作成
2. lucky_number 統合
3. market_sentiment 統合
4. attributes 配列生成
5. 最終検証

バリデーション規則:

- 必須フィールド存在チェック
- データ型検証
- 値範囲検証
- 構造整合性チェック

前回のコードに追加し、NFT メタデータ管理を含む完全なコードで実装してください。
