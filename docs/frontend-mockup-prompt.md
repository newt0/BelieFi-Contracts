# BelieFi DeFAI NFT – AO MAXI フロントエンド モックアップ（v0向けプロンプト）

## 役割
- あなたはWeb/プロダクトデザイナーです。FigmaベースのUIモックを高解像度で作成し、必要に応じて軽量なプロトタイプ（遷移）も付けてください。

## 目的
- 1 USDAでミントできるNFT「AO MAXI」のパブリックミント体験を、わかりやすく・信頼感あるUIで表現。
- ミント後に付与される「ラッキーナンバー（0–999）」と「マーケットセンチメント（bearish / neutral / bullish / very_bullish + 信頼度）」を魅力的に可視化。
- 供給100・1アドレス1枚制限、現在の販売状況、最近のミント状況、所有NFT閲覧、簡易エージェント（DeFAI）状況の可視化を含む。

## ブランド / トーン
- 近未来・クリプト感・信頼性。ダークモード基調、可読性と指標表示（数値/バッジ/プログレス）を重視。
- 推奨カラー（調整可）:
  - Primary: `#00E5A8` / Hover: `#00C896`
  - Accent: `#7C5CFF`
  - Bg: `#0B0F14` / Surface: `#121821` / Border: `#1F2A37`
  - Text: `#E5F0FF` / Muted: `#94A3B8`
  - Sentiment色: bearish=`#EF4444`, neutral=`#64748B`, bullish=`#22C55E`, very_bullish=`#10B981`
- フォント: Inter または Sora。数字はタブラー設定。

## 画面（フレーム）
1. ランディング / ミント
   - ヒーロー: コレクション名「AO MAXI」、説明（“Believing in AO’s growth / Strategy: Maximize $AO”）、ロゴ/ヒーロー画像（プレースホルダ）。
   - ミントカード: 価格「1 USDA」、残り数/進捗バー（例: 37/100 minted）、1アドレス1枚、Mintボタン。
   - ミント状況: 「Mint: Active / Sold out / Paused」バッジ、推定所要時間、注意文（ミントはUSDAトランスファで実行）。
   - 最近のミント: グリッド（最新8件）、「#ID」「ラッキーナンバー」「センチメント（バッジ+confidence）」を表示。
   - FAQ/注意: 返金条件（過不足の自動返金）、1枚制限、RandAO遅延時のフォールバック説明。
2. 自分のNFT
   - 接続アドレス表示、保有数、各NFTカード（Lucky Numberをタイポで強調、センチメントバッジ、confidence%）。
   - メタデータ詳細モーダル: name, image, attributes（Strategy, Rarity Tier, Market Factors）, minted_at, token_id, external_urlリンク。
3. コレクション統計
   - 供給・ミント率・ユニークホルダー数。
   - センチメント分布（円/棒）、ラッキーナンバー帯域分布（0–199 / 200–499 / 500–799 / 800–999）。
   - 市場データ概要（価格/24h出来高/流動性/トレンド%）のカード。
4. ミントフロー（ステップUI）
   - Step 1: アドレス接続/検証
   - Step 2: ミント可否チェック（Eligible/Already minted/Sold out）
   - Step 3: 1 USDA送金（ウォレット呼び出しUIのダミー）。送金先はUSDAトークンプロセスで、Recipientに本プロセスIDを指定する旨の説明コピー。
   - Step 4: 決済確認（“Credit-Notice received”）→ RandAO待機中バナー（スケルトン/ローディング）。
   - Step 5: ミント成功（コンフェッティ、Lucky Number大表示、センチメントバッジ、シェアボタン）。
5. エージェント（DeFAI）概要
   - DCA/Smart Swap/Sentiment Boostの有効状態、日次予算%、スリッページ、残高。
   - 最近の実行履歴カード（タイプ, 金額USDA, 受取AO, 価格, ステータス）。
   - 市場データ更新時間、Dexi購読状態のステータスピル。

## 主要コンポーネント
- Header（ロゴ、ナビ: Mint, My NFT, Stats, Agent）
- Footer（コントラクト説明、リンク）
- MintCard（価格、残り数、CTA、制限アイコン）
- ProgressBar（供給進捗）
- SentimentBadge（4種+colors、confidence%ツールチップ）
- LuckyNumberDisplay（3桁ゼロパディング、視覚的強調）
- NFTCard / Modal（メタデータ、属性リスト）
- StatusPill（Active/Paused/Sold out/RandAO Pending/AI Powered）
- Toast / Inline Alert（返金や失敗理由）
- Empty / Loading / Skeleton

## 状態 / UX
- Mintボタン状態: `idle → checking → awaiting-payment → pending-randao → success / error`
- エラー例: Invalid address, Already minted, Sold out, Insufficient/Overpayment（返金済み）
- 成功例: “NFT #XYZ minted”, “Lucky Number: 777”, “Sentiment: very_bullish (92%)”
- RandAOタイムアウト時: “Fallback applied”バッジ
- アクセシビリティ: コントラスト、キーボード操作、フォーカスリング、ARIA（ボタン/ダイアログ/トースト）

## ダミーデータ（モック）
- コレクション: `name=AO MAXI`, `symbol=AOMAXI`, `max_supply=100`, `price=1 USDA`
- 最近のミント例:
  - `{ id: 021, owner: "addr_xxx…", lucky_number: 777, sentiment: "very_bullish", confidence: 0.92 }`
  - `{ id: 022, owner: "addr_yyy…", lucky_number: 42, sentiment: "bullish", confidence: 0.85 }`
- 自分のNFT:
  - `{ id: 037, name: "AO MAXI #037", lucky_number: 369, sentiment: "neutral", confidence: 0.65, attributes:[…] }`
- 市場データ: `price="0.1234"`, `volume_24h="23456"`, `liquidity="123456"`, `trend=+4.2%`

## コピー（例）
- ヒーロー: “Believe in AO’s growth. Mint AO MAXI for 1 USDA.”
- ミント注意: “Payment via USDA transfer. Over/under payment handled automatically.”
- RandAO待機: “Assigning your Lucky Number… Powered by RandAO (fallback ready).”
- AI出所: “Market Sentiment: Powered by Apus Network AI”

## 技術的補足（説明テキストのみ、UIに反映）
- ミントはUSDAトークンのTransferで実施。モックでは「送金モーダル」の擬似演出でOK。
- 12桁精度は文言で示し、UIでは「1 USDA」で十分。
- 1アドレス1枚制限の明示と再ミント不可の警告。

## レイアウト / レスポンシブ
- デスクトップ: 1440px基準。ヒーロー2カラム（説明/ビジュアル）。
- タブレット: 768px、カード2列。
- モバイル: 360–390px、カード1列、ファーストCTAは常時表示。

## 成果物
- Figmaファイル：
  - フレーム: Landing/Mint, My NFT, Stats, Agent, Global Components
  - コンポーネント化とVariants（ボタン/バッジ/カード/モーダル/トースト/プログレス）
  - ダーク必須（ライトは任意）
  - 簡易プロトタイプ（主要遷移: ミントフロー/詳細モーダル）
- 任意: HeroセクションとMintカードのみの軽量HTMLプレビュー（ダミー）

## 受け入れ基準
- ミント体験の全状態が視覚化され、1ページ目から「供給・価格・制限・CTA」が即理解できる。
- ラッキーナンバーとセンチメントが“誇らしく”見えるデザイン（バッジ/大きな数値/アニメは控えめ）。
- 統計とエージェント概要はカードで瞬時に把握できる。
- モバイルでの可読性と操作性が高い。

