# Directory Structure Guide

## Project Root

```plaintext
my-dapp-project/
├── .claude/                    # 🤖 Claude AI settings
│   ├── project-context.md      # Project context
│   ├── prompts/               # Custom prompts
│   ├── contexts/              # Feature contexts
│   └── workflows/             # Development workflows
├── .github/                   # 🔧 GitHub settings
├── .vscode/                   # 📝 VSCode settings
├── docs/                      # 📚 Documentation
│   ├── ui-design-system.md    # UI design guide
│   ├── state-management.md    # State management guide
│   └── directory-structure.md # This file
├── public/                    # 🌐 Static files
│   ├── favicon.ico
│   ├── logo.svg
│   └── og-image.png
├── src/                       # 💻 Application source
├── .env.example               # 📋 Environment template
├── CLAUDE.md                  # 🤖 Claude Code info
├── README.md                  # 📖 Project overview
├── components.json            # 🎨 shadcn/ui config
├── next.config.ts             # ⚡ Next.js config
├── package.json               # 📦 Package info
├── tailwind.config.ts         # 🎨 Tailwind config
└── tsconfig.json              # 📘 TypeScript config
```

## src/ Directory

```plaintext
src/
├── app/                       # 🚀 Next.js App Router
│   ├── mint/
│   │   └── [id]/page.tsx      # Dynamic routes
│   ├── about/page.tsx
│   ├── profile/page.tsx
│   ├── globals.css            # Global styles
│   ├── layout.tsx             # Root layout
│   └── page.tsx               # Home page
│
├── components/                # 🧩 Reusable components
│   ├── layout/                # Layout components
│   │   ├── Header.tsx
│   │   ├── HeaderNavigation.tsx
│   │   └── Footer.tsx
│   ├── providers/             # Context providers
│   ├── shared/                # Cross-feature shared
│   └── ui/                    # shadcn/ui components
│
├── constants/                 # 📋 Constants & config
│   ├── chain-info/            # Blockchain info
│   ├── contracts/             # Smart contract info
│   ├── meta/                  # SEO & social meta
│   │   ├── brand-copy.ts
│   │   ├── site-metadata.ts
│   │   ├── social-links.ts
│   │   └── external-links.ts
│   ├── common/                # Common constants
│   └── index.ts               # Unified exports
│
├── features/                  # 🎛️ Feature modules
│   └── mint/                  # Mint feature package
│       ├── components/        # Feature components
│       ├── hooks/             # Feature hooks
│       ├── types/             # Feature types
│       └── utils/             # Feature utilities
│
├── hooks/                     # 🎣 Global shared hooks
├── lib/                       # 📚 Libraries & utilities
├── stores/                    # 🏪 Zustand state management
├── types/                     # 📝 Global type definitions
└── utils/                     # 🔧 Global utilities
```

## Key Principles

### 1. Feature-Based Organization

- Group related functionality in `features/`
- Each feature is self-contained
- Cross-feature sharing goes to `components/shared/`

### 2. Next.js App Router

- `app/` for routing only
- Business logic in `features/` and `components/`
- Server/Client components clearly separated

### 3. State Management

- `stores/` for Zustand global state
- Feature-specific state in `features/[name]/hooks/`
- Component state with `useState`

### 4. Shared Resources

- `components/ui/` for shadcn/ui components
- `components/shared/` for cross-feature components
- `constants/` for application-wide constants
- `types/` for global TypeScript definitions

### 5. Development Tools

- `.claude/` for AI-assisted development
- `.vscode/` for team editor settings
- `docs/` for design guides and specifications

## File Naming Conventions

| Type       | Pattern           | Example            |
| ---------- | ----------------- | ------------------ |
| Components | PascalCase        | `WalletButton.tsx` |
| Hooks      | camelCase         | `useMintForm.ts`   |
| Utilities  | camelCase         | `formatAddress.ts` |
| Constants  | UPPER_SNAKE_CASE  | `CHAIN_INFO.ts`    |
| Types      | PascalCase        | `MintState.ts`     |
| Stores     | camelCase + Store | `mintStore.ts`     |

## Import Conventions

```typescript
// Absolute imports with path mapping
import { Button } from "@/components/ui/button";
import { useMintStore } from "@/stores/mintStore";
import { CHAIN_INFO } from "@/constants/chain-info";

// Feature imports
import { MintForm } from "@/features/mint/components/MintForm";
import { useMintForm } from "@/features/mint/hooks/useMintForm";
```

## Best Practices

### Do

- Keep features self-contained
- Use TypeScript for all files
- Export from index files for clean imports
- Group related constants together
- Separate business logic from UI components

### Don't

- Mix feature logic across directories
- Create deep nesting (max 3 levels)
- Put business logic in `app/` directory
- Skip TypeScript types
- Create circular dependencies

This structure supports scalable Web3 dApp development with clear separation of concerns and optimal Claude Code integration.
