# BelieFi DeFAI NFT モックアップ

## 役割

- あなたはフロントエンド生成 AI（v0 等）に実装可能な仕様・制約・UI 要件を提示するプロダクトデザイナー/UX エンジニアです。
- 成果物は Next.js + TypeScript + Tailwind CSS + shadcn-ui のコードモックです（Figma は任意・説明/共有用途のみ）。
- 本仕様は「AO Platform Integrated Design Guide」および「Web3 dApps UI Design Guide」の原則・トークン・インタラクションに準拠します。

### 生成 AI 向けプロンプト指針（v0）
- 明示すること: ルート構成、主要コンポーネント、状態遷移、色/タイポ/ボーダー/間隔のトークン、アクセシビリティ要件。
- 制約: ライトモードのみ、装飾画像禁止、アニメーション<=200ms、サブトラクティブ（最小主義）。
- 期待出力: ルーティング済みのページ雛形、shadcn コンポーネントの Variant 設定、Tailwind テーマ拡張、Skeleton/Empty/Toast の状態実装。

## 目的

- 1 USDA でミントできる NFT「AO MAXI」のパブリックミント体験を、わかりやすく・信頼感ある UI で表現。
- ミント後に付与される「ラッキーナンバー（0–999）」と「マーケットセンチメント（bearish / neutral / bullish / very_bullish + 信頼度）」を魅力的に可視化。
- 供給 100・1 アドレス 1 枚制限、現在の販売状況、最近のミント状況、所有 NFT 閲覧、簡易エージェント（DeFAI）状況の可視化を含む。

## BelieFi コンテキスト

- プロダクト名は「BelieFi」。本仕様は BelieFi の DeFAI NFT ラインの一つ「AO MAXI」に対するもの。
- そのほかの DeFAI NFT: 「The Tate Strategist」「Permaweb Arbitrager」（いずれも Coming Soon）。
- ヘッダーに「プロダクトスイッチャー」を配置：
  - `AO MAXI`（Active/現在ページ）
  - `The Tate Strategist`（Coming Soon / 非活性）
  - `Permaweb Arbitrager`（Coming Soon / 非活性）
  - 表示は最小限（テキスト + 小さなピル）、押下不能な項目は明確に無効表示。

## ブランドコピー（固定文言）

- Tagline: "Vibe Trading on belief. DeFAI Agent as NFT"
- CTA: "Mint your DeFAI NFT."
- SEO_Description: "Mint your DeFAI NFT and start vibe trading on belief. Each DeFAI Agent combines NFT, Smart Wallet, and AI Agent to deliver a real DeFAI UX."
- OG_Description: "Mint your DeFAI NFT. Vibe trading on belief starts here with NFT + Smart Wallet + AI Agent."

使用箇所（ルール）
- Hero: 見出し or サブ見出しに Tagline を使用（改行/句点の装飾は加えない）。
- メイン CTA: Mint 開始ボタンのラベルは CTA を使用。
- SEO: `app/layout.tsx` の既定 `metadata.description` に SEO_Description を設定。
- OGP: `metadata.openGraph.description` と `twitter.description` に OG_Description を設定。
- 文体: 句読点・絵文字・過度な形容を避け、最小限で明快に表現。

## ブランド / トーン（AO ガイド適用）

- サブトラクティブ（引き算）美学：要素・色・装飾を最小限にし、情報伝達を最優先。
- 静的で秩序立った構造：縦スクロール中心の単一カラム、一定のリズムと余白、一貫した配置。
- 非侵襲な UX：必要情報は常に視界内、不要要素は控えめ。状態遷移は簡潔で予測可能。
- ライトモードのみ（ダークは不要）。
- 画像は NFT・トークンアイコン・ロゴに限定（装飾画像は不可）。
- アニメーションは 200ms 以下、過度な動きは抑制。

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
- セマンティックカラー（Tailwind 参照値）:
  - Success: `green-600`（例: ウォレット接続成功、TX 成功）
  - Warning: `yellow-400`（例: 高ガス、注意）
  - Error: `red-500`（例: 失敗、高リスク）
  - Info: `blue-500`（例: 補足情報）
- タイポグラフィ:
  - フォント: Sans-serif（Manrope または Inter 系）
  - サイズ: ベース `14px`〜`18px`
  - 強調: 見出し・数値は `600–700`、補助は `400以下 + 小さめ + グレー`

### グローバル構造

- ヘッダー: 左に`BelieFi`ロゴ、中央〜右に`プロダクトスイッチャー`、その右に本プロダクトのナビ（`Mint` / `My NFT` / `Stats` / `Agent`）。
  - 背景は白、影/ボーダーは原則無し（必要時は`#DDDDDD`の 1px に限定）。
  - オプション: `sticky top-0 bg-white/95 backdrop-blur`（境界は極薄）—可読性最優先の範囲で使用可。
- フッター: `DISCORD` / `GITHUB` / `POLICIES` のみ。最小・控えめ配置。

## 画面（フレーム）

0. プロダクト選択（任意のトップ）
   - AO MAXI（Active）を主要カードで提示。ほか 2 点は「Coming Soon」ピル付きの非活性カード。
   - クリックで AO MAXI のミントページへ遷移。
1. ランディング / ミント
   - ヒーロー: コレクション名「AO MAXI」、説明（“Believing in AO’s growth / Strategy: Maximize $AO”）。ビジュアルは控えめ、余白と見出しで強調。
   - ミントカード: 価格「1 USDA」、残り数/進捗（例: 37/100 minted）、1 アドレス 1 枚、Mint ボタン。ボーダーは `#DDDDDD`、ホバー時 `#707070`。
   - ステータス: 「Mint: Active / Sold out / Paused」ピル。色は控えめ、状態は色で明確化（Active はプライマリグリーン）。
   - 最近のミント: 最新 8 件のシンプルグリッド。「#ID」「ラッキーナンバー」「センチメント（バッジ+confidence）」。
   - 注意/FAQ: 過不足時の自動返金、1 枚制限、RandAO 遅延時のフォールバック等。
2. 自分の NFT
   - 接続アドレス（右上ウォレットボタンのミニモーダル対応: `Copy / Explorer / Disconnect`）。
   - 保有数、各 NFT カード（Lucky Number を太字で強調、センチメントバッジ、confidence%）。
   - メタデータ詳細モーダル（右スライドイン / 480px 固定）: name, image, attributes（Strategy, Rarity Tier, Market Factors）, minted_at, token_id, external_url。
3. コレクション統計
   - 供給・ミント率・ユニークホルダー数。
   - センチメント分布（円/棒）、ラッキーナンバー帯域分布（0–199 / 200–499 / 500–799 / 800–999）。
   - 市場データ概要（価格/24h 出来高/流動性/トレンド%）のカード。視覚ノイズを抑え、数値と単位を整然と表示。
4. ミントフロー（ステップ UI）
   - Step 1: アドレス接続/検証
   - Step 2: ミント可否チェック（Eligible/Already minted/Sold out）
   - Step 3: 1 USDA 送金（ウォレット呼び出し UI のダミー）。送金先は USDA トークンプロセス、Recipient に本プロセス ID を指定する説明コピー。
   - Step 4: 決済確認（“Credit-Notice received”）→ RandAO 待機中（スケルトン/ローディング）。
   - Step 5: ミント成功（控えめな演出、Lucky Number を大きく、センチメントはバッジ）。
5. エージェント（DeFAI）概要
   - DCA/Smart Swap/Sentiment Boost の有効状態、日次予算%、スリッページ、残高。
   - 実行履歴カード（タイプ, 金額 USDA, 受取 AO, 価格, ステータス）。
   - 市場データ更新時間、購読状態ピル。状態は色で示し、形状は統一。

## 主要コンポーネント（AO ガイド適用）

- `Header`（左: `BelieFi`ロゴ / 中央〜右: `プロダクトスイッチャー` / 右: AO MAXI のセクションナビ `Mint` `My NFT` `Stats` `Agent`）
- `Footer`（`DISCORD` / `GITHUB` / `POLICIES`）
- `MintCard`（価格、残り数、CTA、制限アイコン。枠線`#DDDDDD`、ホバー`#707070`）
- `ProgressBar`（供給進捗。色はプライマリグリーン）
- `SentimentBadge`（bearish/neutral/bullish/very_bullish。色は控えめ、テキスト判読性優先）
- `LuckyNumberDisplay`（3 桁ゼロパディング、見出しウェイト`600–700`）
- `NFTCard / Right-Slide Modal`（詳細は右から固定幅 480px でスライドイン）
- `StatusPill`（Active/Paused/Sold out/RandAO Pending/AI Powered）
- `Toast / Inline Alert`（返金や失敗理由。過度なアニメは避ける）
- `Empty / Loading / Skeleton`（骨組みはグレー階調で静的）
- `ProductSwitcher`（`AO MAXI`=Active、`The Tate Strategist`/`Permaweb Arbitrager`=Coming Soon）

### ボタン（スタイルと状態）

- プライマリ（緑）: `#00C853` → Hover: `#23BE30`、文字は白、境界は背景色同系。
- セカンダリ（白）: 背景`#FAFAFA`、ホバーで薄いグレー背景 + 濃いボーダー。
- Disabled: グレイアウト、カーソル変更なし、`disabled`で状態制御。
- ユーティリティ/ナビ用（中立 CTA）: `bg-black hover:bg-gray-900 text-white` を可（Mint 等の主要行為は緑を優先）。
- ローディング: `opacity-50` + アイコン`animate-spin`（200ms 以内）

### ウォレット ミニモーダル

- 右上ドロップダウン／右下開き。`Copy` / `Explorer` / `Disconnect` の 3 アクション。
- 高い視認性だが主張は控えめ。

#### ウォレットボタン（挙動例）

- 未接続: `bg-black hover:bg-gray-800 text-white`（アイコン + テキスト）。
- 接続中: スピナー表示（`animate-spin`）。
- 接続済: `bg-green-600 hover:bg-green-700 text-white` + 短縮アドレス表示。

## 状態 / UX（AO ガイド適用）

- ボタン状態: `idle → checking → awaiting-payment → pending-randao → success / error`（色で明瞭化、アニメは最小）
- 入力エラー: 入力欄のボーダーのみ赤（`#F44336`）。
- 有効入力: プライマリボタンが有効化（緑）。
- タブ切替: アクティブは `border-bottom: 2px solid #00C853`。
- カウントダウン等がある場合はリアルタイム更新（Withdraw 相当 UI が登場する場合に準拠）。
- アクセシビリティ: コントラスト、キーボード操作、フォーカスリング、ARIA（ボタン/ダイアログ/トースト）。
- ローディング/成功/失敗: `gray-50`の控えめなカード、`green-100`/`red-50`等を使用し過度な演出は避ける。

## ダミーデータ（モック）

- コレクション: `name=AO MAXI`, `symbol=AOMAXI`, `max_supply=100`, `price=1 USDA`
- 最近のミント例:
  - `{ id: 021, owner: "addr_xxx…", lucky_number: 777, sentiment: "very_bullish", confidence: 0.92 }`
  - `{ id: 022, owner: "addr_yyy…", lucky_number: 42, sentiment: "bullish", confidence: 0.85 }`
- 自分の NFT:
  - `{ id: 037, name: "AO MAXI #037", lucky_number: 369, sentiment: "neutral", confidence: 0.65, attributes:[…] }`
- 市場データ: `price="0.1234"`, `volume_24h="23456"`, `liquidity="123456"`, `trend=+4.2%`

## コピー（例）

- ヒーロー: “Vibe Trading on belief. DeFAI Agent as NFT”
- ミント注意: “Payment via USDA transfer. Over/under payment handled automatically.”
- RandAO 待機: “Assigning your Lucky Number… Powered by RandAO (fallback ready).”
- AI 出所: “Market Sentiment: Powered by Apus Network AI”

### Next.js メタデータ例（App Router）
```ts
// app/layout.tsx
export const metadata = {
  title: 'BelieFi — AO MAXI',
  description: 'Mint your DeFAI NFT and start vibe trading on belief. Each DeFAI Agent combines NFT, Smart Wallet, and AI Agent to deliver a real DeFAI UX.',
  openGraph: {
    title: 'BelieFi — AO MAXI',
    description: 'Mint your DeFAI NFT. Vibe trading on belief starts here with NFT + Smart Wallet + AI Agent.',
    type: 'website'
  },
  twitter: {
    card: 'summary_large_image',
    title: 'BelieFi — AO MAXI',
    description: 'Mint your DeFAI NFT. Vibe trading on belief starts here with NFT + Smart Wallet + AI Agent.'
  }
}
```

## 技術的補足（説明テキストのみ、UI に反映）

- ミントは USDA トークンの Transfer で実施。モックでは「送金モーダル」の擬似演出で OK。
- 12 桁精度は文言で示し、UI では「1 USDA」で十分。
- 1 アドレス 1 枚制限の明示と再ミント不可の警告。

## レイアウト / レスポンシブ

- ページ全体は単一カラムの縦スクロールを基本。リズムと余白は一定。
- デスクトップ: 1440px 基準。ヒーローは説明中心で静的。
- タブレット: 768px、カード 2 列。
- モバイル: 360–390px、カード 1 列、主要 CTA は常時視認可能。

## 成果物（Next.js モックアップ / 技術スタック）

- Tech: `Next.js`（App Router 推奨）, `TypeScript`, `tailwindcss`, `shadcn-ui`
- 推奨ライブラリ: `zustand`（グローバル状態）, `react-hook-form`（バリデーション）
- ルーティング（例）
  - `/` … プロダクト選択（任意）または AO MAXI ランディング
  - `/mint` … AO MAXI ミント（ランディング兼用可）
  - `/my` … My NFT
  - `/stats` … コレクション統計
  - `/agent` … DeFAI 概要
- ディレクトリ構成（例）
  - `app/(routes)/{page}/page.tsx` … 各ページ
  - `components/ui/*` … `shadcn-ui`導入コンポーネント
  - `components/*` … `MintCard`, `SentimentBadge`, `LuckyNumberDisplay`, `StatusPill`, `WalletDropdown`, `RightSheet`, `ProductSwitcher`
  - `lib/design-tokens.ts` … カラー/タイポ/スペーシング（tailwind.theme 反映）
  - `styles/globals.css` … ベース/ユーティリティ（ライト基調、必要ならダークも）
- Tailwind 設定
  - `theme.extend.colors` に `#00C853`（hover: `#23BE30`）, `#DDDDDD`, `#707070`, `#F0F0F0`, `#FAFAFA` 等を登録
  - フォントは Manrope/Inter を設定、数字はタブラー（`tabular-nums`）
- Tailwind テーマ例（併用可）
  - `neutral`: `{ background: #fff, surface: #f4f4f4, border: #e5e7eb, text: #000, subtext: #6b7280 }`
  - `semantic`: `{ success: #16A34A, warning: #FACC15, danger: #EF4444, info: #3B82F6 }`
  - `state`: `{ primary: #000000, onPrimary: #ffffff, disabled: #d1d5db }`
- shadcn-ui
  - Button（primary/secondary/disabled）, Tabs（下線=2px green）, Dialog/Sheet（右スライド固定幅 480px）, DropdownMenu（Wallet/製品切替）を採用
- 画面実装要件
  - 主要状態（`idle → checking → awaiting-payment → pending-randao → success/error`）が UI で判別可能
  - 入力エラーはフィールド境界のみ赤表示
  - Skeleton/Empty/Toast を用意、アニメは抑制

## 受け入れ基準

- AO デザインガイドの原則（最小・秩序・非侵襲）がページ全体で守られている。
- ミント体験の全状態が視覚化され、1 ページ目から「供給・価格・制限・CTA」が即理解できる。
- ラッキーナンバーとセンチメントが“誇らしく”見えるが、演出は抑制的で可読性を最優先。
- 統計とエージェント概要はカードで瞬時に把握できる。
- モバイルでの可読性と操作性が高い。
- Next.js モックアップで上記各ページがナビゲート可能（ヘッダーの ProductSwitcher 含む）。
- tailwind + shadcn-ui のスタイルトークンが AO ガイドの色/境界/動作に一致。
- ライトモードのみ（Dark 未対応で可）。
- 画像使用は NFT/トークン/ロゴに限定。アニメーションは 200ms 以下。
- Brand Copy（Tagline/CTA/SEO/OG）が UI とメタデータに適用されている。
