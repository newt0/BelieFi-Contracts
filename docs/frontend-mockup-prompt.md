# BelieFi DeFAI NFT – AO MAXI フロントエンド モックアップ（v0向けプロンプト / AOデザインガイド適用）

## 役割
- あなたはWeb/プロダクトデザイナーです。FigmaベースのUIモックを高解像度で作成し、必要に応じて軽量なプロトタイプ（遷移）も付けてください。
- 本モックは「AO Platform Integrated Design Guide」の原則・トークン・インタラクションに準拠します。

## 目的
- 1 USDAでミントできるNFT「AO MAXI」のパブリックミント体験を、わかりやすく・信頼感あるUIで表現。
- ミント後に付与される「ラッキーナンバー（0–999）」と「マーケットセンチメント（bearish / neutral / bullish / very_bullish + 信頼度）」を魅力的に可視化。
- 供給100・1アドレス1枚制限、現在の販売状況、最近のミント状況、所有NFT閲覧、簡易エージェント（DeFAI）状況の可視化を含む。

## ブランド / トーン（AOガイド適用）
- サブトラクティブ（引き算）美学：要素・色・装飾を最小限にし、情報伝達を最優先。
- 静的で秩序立った構造：縦スクロール中心の単一カラム、一定のリズムと余白、一貫した配置。
- 非侵襲なUX：必要情報は常に視界内、不要要素は控えめ。状態遷移は簡潔で予測可能。
- デフォルトはライト基調。ダークは任意（優先度低）。

### デザイン・トークン（スタイル仕様）
- カラー:
  - 背景: `#FFFFFF`
  - 文字（主）: `#000000`
  - 文字（補）: `#666666` / `#999999`
  - 成功アクセント/プライマリ: `#00C853`（Hover: `#23BE30`）
  - 警告テキスト: `#FF1744`
  - ホバー背景: `#F0F0F0`
  - ボーダー: 通常 `#DDDDDD` / ホバー時 `#707070`
  - セカンダリボタン背景: `#FAFAFA`
- タイポグラフィ:
  - フォント: Sans-serif（Manrope または Inter 系）
  - サイズ: ベース `14px`〜`18px`
  - 強調: 見出し・数値は `600–700`、補助は `400以下 + 小さめ + グレー`

### グローバル構造
- ヘッダー: ロゴ + ナビ（`DELEGATE` / `MINT` / `BUILD`）。ホワイト背景、ボーダー無し、全ページで統一。
- フッター: `DISCORD` / `GITHUB` / `POLICIES` のみ。最小・控えめ配置。

## 画面（フレーム）
1. ランディング / ミント
   - ヒーロー: コレクション名「AO MAXI」、説明（“Believing in AO’s growth / Strategy: Maximize $AO”）。ビジュアルは控えめ、余白と見出しで強調。
   - ミントカード: 価格「1 USDA」、残り数/進捗（例: 37/100 minted）、1アドレス1枚、Mintボタン。ボーダーは `#DDDDDD`、ホバー時 `#707070`。
   - ステータス: 「Mint: Active / Sold out / Paused」ピル。色は控えめ、状態は色で明確化（Activeはプライマリグリーン）。
   - 最近のミント: 最新8件のシンプルグリッド。「#ID」「ラッキーナンバー」「センチメント（バッジ+confidence）」。
   - 注意/FAQ: 過不足時の自動返金、1枚制限、RandAO遅延時のフォールバック等。
2. 自分のNFT
   - 接続アドレス（右上ウォレットボタンのミニモーダル対応: `Copy / Explorer / Disconnect`）。
   - 保有数、各NFTカード（Lucky Numberを太字で強調、センチメントバッジ、confidence%）。
   - メタデータ詳細モーダル（右スライドイン / 480px固定）: name, image, attributes（Strategy, Rarity Tier, Market Factors）, minted_at, token_id, external_url。
3. コレクション統計
   - 供給・ミント率・ユニークホルダー数。
   - センチメント分布（円/棒）、ラッキーナンバー帯域分布（0–199 / 200–499 / 500–799 / 800–999）。
   - 市場データ概要（価格/24h出来高/流動性/トレンド%）のカード。視覚ノイズを抑え、数値と単位を整然と表示。
4. ミントフロー（ステップUI）
   - Step 1: アドレス接続/検証
   - Step 2: ミント可否チェック（Eligible/Already minted/Sold out）
   - Step 3: 1 USDA送金（ウォレット呼び出しUIのダミー）。送金先はUSDAトークンプロセス、Recipientに本プロセスIDを指定する説明コピー。
   - Step 4: 決済確認（“Credit-Notice received”）→ RandAO待機中（スケルトン/ローディング）。
   - Step 5: ミント成功（控えめな演出、Lucky Numberを大きく、センチメントはバッジ）。
5. エージェント（DeFAI）概要
   - DCA/Smart Swap/Sentiment Boostの有効状態、日次予算%、スリッページ、残高。
   - 実行履歴カード（タイプ, 金額USDA, 受取AO, 価格, ステータス）。
   - 市場データ更新時間、購読状態ピル。状態は色で示し、形状は統一。

## 主要コンポーネント（AOガイド適用）
- `Header`（ロゴ、ナビ: `DELEGATE` / `MINT` / `BUILD`。白背景、影/罫線は原則無し）
- `Footer`（`DISCORD` / `GITHUB` / `POLICIES`）
- `MintCard`（価格、残り数、CTA、制限アイコン。枠線`#DDDDDD`、ホバー`#707070`）
- `ProgressBar`（供給進捗。色はプライマリグリーン）
- `SentimentBadge`（bearish/neutral/bullish/very_bullish。色は控えめ、テキスト判読性優先）
- `LuckyNumberDisplay`（3桁ゼロパディング、見出しウェイト`600–700`）
- `NFTCard / Right-Slide Modal`（詳細は右から固定幅480pxでスライドイン）
- `StatusPill`（Active/Paused/Sold out/RandAO Pending/AI Powered）
- `Toast / Inline Alert`（返金や失敗理由。過度なアニメは避ける）
- `Empty / Loading / Skeleton`（骨組みはグレー階調で静的）

### ボタン（スタイルと状態）
- プライマリ（緑）: `#00C853` → Hover: `#23BE30`、文字は白、境界は背景色同系。
- セカンダリ（白）: 背景`#FAFAFA`、ホバーで薄いグレー背景 + 濃いボーダー。
- Disabled: グレイアウト、カーソル変更なし、`disabled`で状態制御。

### ウォレット ミニモーダル
- 右上ドロップダウン／右下開き。`Copy` / `Explorer` / `Disconnect` の3アクション。
- 高い視認性だが主張は控えめ。

## 状態 / UX（AOガイド適用）
- ボタン状態: `idle → checking → awaiting-payment → pending-randao → success / error`（色で明瞭化、アニメは最小）
- 入力エラー: 入力欄のボーダーのみ赤（`#F44336`）。
- 有効入力: プライマリボタンが有効化（緑）。
- タブ切替: アクティブは `border-bottom: 2px solid #00C853`。
- カウントダウン等がある場合はリアルタイム更新（Withdraw相当UIが登場する場合に準拠）。
- アクセシビリティ: コントラスト、キーボード操作、フォーカスリング、ARIA（ボタン/ダイアログ/トースト）。

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
- ページ全体は単一カラムの縦スクロールを基本。リズムと余白は一定。
- デスクトップ: 1440px基準。ヒーローは説明中心で静的。
- タブレット: 768px、カード2列。
- モバイル: 360–390px、カード1列、主要CTAは常時視認可能。

## 成果物
- Figmaファイル：
  - フレーム: Landing/Mint, My NFT, Stats, Agent, Global Components
  - コンポーネント化とVariants（ボタン/バッジ/カード/モーダル/トースト/プログレス）
  - ライト基調必須（ダークは任意）
  - 簡易プロトタイプ（主要遷移: ミントフロー/詳細モーダル）
- 任意: HeroセクションとMintカードのみの軽量HTMLプレビュー（ダミー）

## 受け入れ基準
- AOデザインガイドの原則（最小・秩序・非侵襲）がページ全体で守られている。
- ミント体験の全状態が視覚化され、1ページ目から「供給・価格・制限・CTA」が即理解できる。
- ラッキーナンバーとセンチメントが“誇らしく”見えるが、演出は抑制的で可読性を最優先。
- 統計とエージェント概要はカードで瞬時に把握できる。
- モバイルでの可読性と操作性が高い。
