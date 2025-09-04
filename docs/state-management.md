# State Management Guide

## Core Principles

- Zustand: Global state management
- React Hook Form: Form state management
- useState: Component state
- No other libraries (Context, Redux, Jotai, etc.)

## State Classification

| Type            | Tool            | Examples                         |
| --------------- | --------------- | -------------------------------- |
| Global State    | Zustand         | Wallet connection, notifications |
| Form State      | React Hook Form | Input, validation                |
| Component State | useState        | Modals, local UI                 |
| Server State    | TanStack Query  | API data (future)                |

## Zustand Store Design

### Domain-Based Separation

```typescript
src/stores/
├── mintStore.ts      // Mint functionality
├── walletStore.ts    // Wallet connection
├── uiStore.ts        // UI state
└── nftStore.ts       // NFT data
```

### Store Structure

```typescript
import { create } from "zustand";
import { devtools } from "zustand/middleware";

interface MintStore {
  mintingState: "idle" | "minting" | "success" | "error";
  mintedNftId: string | null;
  errorMessage: string | null;
  mintAgent: () => Promise<void>;
  resetMintState: () => void;
}

export const useMintStore = create<MintStore>()(
  devtools(
    (set, get) => ({
      mintingState: "idle",
      mintedNftId: null,
      errorMessage: null,

      mintAgent: async () => {
        try {
          set({ mintingState: "minting", errorMessage: null });
          // mint logic
          set({ mintingState: "success" });
        } catch (error) {
          set({
            mintingState: "error",
            errorMessage: error.message,
          });
        }
      },

      resetMintState: () => {
        set({
          mintingState: "idle",
          mintedNftId: null,
          errorMessage: null,
        });
      },
    }),
    { name: "mint-store" }
  )
);
```

### Persistence (When Needed)

```typescript
import { persist } from "zustand/middleware";

export const useUIStore = create<UIStore>()(
  devtools(
    persist(
      (set, get) => ({
        sidebarOpen: false,
        theme: "light",
        // ...
      }),
      {
        name: "ui-store",
        partialize: (state) => ({
          sidebarOpen: state.sidebarOpen,
          theme: state.theme,
        }),
      }
    ),
    { name: "ui-store" }
  )
);
```

### Retry Functionality

```typescript
retryMint: async () => {
  const { retryCount, maxRetries } = get();

  if (retryCount >= maxRetries) {
    set({ errorMessage: "Max retries exceeded", mintingState: "error" });
    return;
  }

  set({ retryCount: retryCount + 1 });
  const delay = Math.min(1000 * Math.pow(2, retryCount), 10000);
  await new Promise(resolve => setTimeout(resolve, delay));

  await get().mintAgent();
},
```

## React Hook Form Integration

### Custom Hook

```typescript
export const useMintForm = () => {
  const {
    selectedStrategy,
    mintPrice,
    updateConfig,
    estimateGas,
    isWalletConnected,
  } = useMintStore();

  useEffect(() => {
    if (isWalletConnected && selectedStrategy && mintPrice) {
      estimateGas();
    }
  }, [isWalletConnected, selectedStrategy, mintPrice, estimateGas]);

  const handleConfigChange = (field: string, value: string) => {
    updateConfig({ [field]: value });
  };

  const isFormValid = selectedStrategy && mintPrice && isWalletConnected;

  return {
    selectedStrategy,
    mintPrice,
    isFormValid,
    handleConfigChange,
  };
};
```

### Form Usage Example

```tsx
export const AgentConfiguration = () => {
  const { selectedStrategy, mintPrice, isFormValid, handleConfigChange } =
    useMintForm();

  return (
    <form>
      <Select
        value={selectedStrategy}
        onValueChange={(value) => handleConfigChange("strategy", value)}
      >
        {/* options */}
      </Select>
      <Input
        value={mintPrice}
        onChange={(e) => handleConfigChange("mintPrice", e.target.value)}
      />
      <Button disabled={!isFormValid}>Mint Agent</Button>
    </form>
  );
};
```

## Next.js App Router Support

### Server/Client Components Separation

```tsx
// Server Component
export default function MintPage() {
  return (
    <div>
      <h1>Mint Agent</h1>
      <MintUIPanel />
    </div>
  );
}

// Client Component
("use client");
export const MintUIPanel = () => {
  const { mintingState, mintAgent } = useMintStore();
  // ...
};
```

### SSR Support

```typescript
"use client";
export const WalletStatus = () => {
  const [mounted, setMounted] = useState(false);
  const { isWalletConnected, walletAddress } = useWalletStore();

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) {
    return <div>Loading...</div>;
  }

  return (
    <div>
      {isWalletConnected ? (
        <span>Connected: {walletAddress}</span>
      ) : (
        <span>Not connected</span>
      )}
    </div>
  );
};
```

## Notification System

```typescript
addNotification: (notification) => {
  const id = `notification-${Date.now()}`;
  const newNotification = { ...notification, id, timestamp: Date.now() };

  set((state) => ({
    notifications: [...state.notifications, newNotification],
  }));

  if (notification.duration !== 0) {
    const duration = notification.duration || 5000;
    setTimeout(() => {
      get().removeNotification(id);
    }, duration);
  }
},
```

## Performance Optimization

### Selector Pattern

```typescript
// ✅ Good: Subscribe to specific state only
const useMintingStatus = () =>
  useMintStore((state) => ({
    mintingState: state.mintingState,
    errorMessage: state.errorMessage,
  }));

// ❌ Bad: Subscribe to entire store
const store = useMintStore();
```

### React.memo Optimization

```tsx
import { memo } from "react";

export const WalletStatus = memo(() => {
  const isConnected = useWalletStore((state) => state.isConnected);
  return <div>{isConnected ? "Connected" : "Disconnected"}</div>;
});
```

## Error Handling

```typescript
const handleAsyncAction = async (
  actionName: string,
  action: () => Promise<void>
) => {
  try {
    set({ [`${actionName}Loading`]: true, [`${actionName}Error`]: null });
    await action();
    set({ [`${actionName}Loading`]: false });
  } catch (error) {
    const errorMessage =
      error instanceof Error ? error.message : `${actionName} failed`;
    set({
      [`${actionName}Loading`]: false,
      [`${actionName}Error`]: errorMessage,
    });

    useUIStore.getState().addNotification({
      type: "error",
      title: `${actionName} Failed`,
      message: errorMessage,
    });
  }
};
```

## Summary

### Recommended

- Separate stores by feature
- Use DevTools middleware
- Minimal persistence
- Custom Hooks for Zustand + React Hook Form integration
- Selectors for specific state subscription
- Unified error handling

### Prohibited

- Multiple library usage (Context, Redux, Jotai, etc.)
- Store bloat (all features in one store)
- Direct set() calls from outside
- Full state localStorage persistence
