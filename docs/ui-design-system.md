# Web3 dApps UI Design Guide

## Core Principles

- Minimal and meaningful color usage in UI
- NFTs and tokens are the main focus, UI is supporting
- Use only functional colors, not decorative ones

## Color System

### 1. Neutral Colors (95% of UI)

| Purpose          | Tailwind               |
| ---------------- | ---------------------- |
| Background       | `white`, `gray-50`     |
| Text (Primary)   | `black`, `gray-900`    |
| Text (Secondary) | `gray-500`, `gray-600` |
| Borders          | `gray-200`, `gray-300` |

### 2. Semantic Colors

| Meaning | Purpose                      | Tailwind     |
| ------- | ---------------------------- | ------------ |
| Success | Wallet connected, TX success | `green-600`  |
| Warning | High gas, caution            | `yellow-400` |
| Error   | Failed, high risk            | `red-500`    |
| Info    | Tips, supplementary          | `blue-500`   |

### 3. Interaction States

| State    | Implementation                         |
| -------- | -------------------------------------- |
| Normal   | `bg-black text-white`                  |
| Hover    | `hover:bg-gray-900 hover:shadow-sm`    |
| Disabled | `bg-gray-300 text-gray-500 opacity-50` |
| Loading  | `opacity-50` + `animate-spin`          |

## Implementation Patterns

### Header & Navigation

```tsx
<header className="sticky top-0 z-40 border-b border-gray-200 bg-white/95 backdrop-blur">
  <div className="container mx-auto px-4">
    <div className="flex h-16 items-center justify-between">
      <Logo />
      <Navigation />
      <WalletButton />
    </div>
  </div>
</header>
```

Navigation states:

- Active: `bg-black text-white`
- Hover: `hover:bg-gray-100`
- Focus: `focus:ring-2 focus:ring-gray-400`

### Wallet Button

```tsx
<Button
  className={`
    ${
      isConnected
        ? "bg-green-600 hover:bg-green-700"
        : "bg-black hover:bg-gray-800"
    } text-white transition-all duration-200
  `}
>
  {isConnecting ? (
    <>
      <Zap className="mr-2 h-4 w-4 animate-spin" />
      Connecting...
    </>
  ) : isConnected ? (
    <>
      <CheckCircle className="mr-2 h-4 w-4" />
      {formatAddress(address)}
    </>
  ) : (
    <>
      <Wallet className="mr-2 h-4 w-4" />
      Connect Wallet
    </>
  )}
</Button>
```

### Mint Button

```tsx
<Button
  onClick={handleMint}
  disabled={!isValid || isMinting}
  className="w-full bg-black hover:bg-gray-800 text-white"
  size="lg"
>
  {isMinting ? (
    <>
      <Zap className="mr-2 h-5 w-5 animate-spin" />
      Minting NFT...
    </>
  ) : (
    "Mint NFT"
  )}
</Button>
```

### Loading States

```tsx
// Processing
<div className="text-center p-3 bg-gray-50 border border-gray-200 rounded-lg">
  <div className="text-sm text-black">🔄 Processing transaction...</div>
  <div className="text-xs text-gray-600 mt-1">Gas: {gasEstimate}</div>
</div>

// Error state
<div className="text-center p-4 bg-red-50 border border-red-200 rounded-lg">
  <div className="text-sm text-red-600 font-medium mb-2">
    Minting Failed (Attempt {retryCount}/{maxRetries})
  </div>
  <div className="text-sm text-red-500 mb-3">{errorMessage}</div>
  <Button className="text-yellow-700 border-yellow-300 hover:bg-yellow-50">
    <Zap className="mr-1 h-3 w-3" />
    Retry
  </Button>
</div>

// Success state
<div className="w-24 h-24 bg-gradient-to-br from-green-100 to-green-200 rounded-full flex items-center justify-center mx-auto mb-6 shadow-lg">
  <CheckCircle className="h-14 w-14 text-green-600" />
</div>
<h1 className="text-3xl font-bold text-black mb-4">
  🎉 Successfully Minted!
</h1>
```

### Risk Level Display

```tsx
const getRiskColor = (level: string) => {
  const colors = {
    High: "text-red-600 bg-red-100",
    "Medium-High": "text-orange-600 bg-orange-100",
    Medium: "text-yellow-600 bg-yellow-100",
    Low: "text-green-600 bg-green-100",
  };
  return colors[level] || "text-gray-600 bg-gray-100";
};
```

## Tech Stack

- Next.js + Tailwind CSS + shadcn/ui
- Zustand for global state management
- react-hook-form for form validation
- TypeScript enforcement

## Design Rules

- Light Mode only (no Dark Mode)
- Images allowed only for NFTs, token icons, and logos
- Animations under 200ms
- Icons + text for accessibility

### Responsive Design

```tsx
// Mobile-first approach
<div className="hidden md:flex items-center space-x-6">
  <Navigation />
</div>
<div className="md:hidden flex items-center space-x-2">
  <MobileButton />
</div>
```

## Tailwind Theme Configuration

```ts
theme: {
  colors: {
    neutral: {
      background: "#ffffff",
      surface: "#f4f4f4",
      border: "#e5e7eb",
      text: "#000000",
      subtext: "#6b7280"
    },
    semantic: {
      success: "#16A34A",
      warning: "#FACC15",
      danger: "#EF4444",
      info: "#3B82F6"
    },
    state: {
      primary: "#000000",
      onPrimary: "#ffffff",
      disabled: "#d1d5db"
    }
  }
}
```

## Benefits

- High usability: Intuitive wallet connection flow
- Consistent UX: Unified experience across all screen sizes
- Maintainability: shadcn/ui + Tailwind combination
- Scalability: Component separation and Zustand utilization
