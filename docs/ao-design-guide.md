# AO Platform Integrated Design Guide

## 1. Overall Design Principles

### 1.1 Subtractive Aesthetics
- Reduce colors, elements, borders, and decorations to the minimum, focusing on information communication
- Present only necessary information and thoroughly eliminate visual noise

### 1.2 Static and Orderly Structure
- Overall page follows a vertical scroll-based single column layout
- Maintains consistent rhythm and spacing throughout
- Predictable and consistent layout design

### 1.3 Non-Intrusive User Experience
- Necessary information is always within the visible range, unnecessary elements stay unobtrusive
- State transitions are simple and predictable
- Design that doesn't hinder user operation flow

## 2. Style Specifications (Design Tokens)

### 2.1 Color Palette

| Usage                     | Color                                   |
| ------------------------- | --------------------------------------- |
| Background                | `#FFFFFF`                               |
| Text (Main)               | `#000000`                               |
| Text (Secondary)          | `#666666` / `#999999`                   |
| Success Accent            | `#00C853` (Primary Green)               |
| Warning Text              | `#FF1744` (When withdrawal unavailable) |
| Hover Background          | `#F0F0F0`                               |
| Border                    | `#DDDDDD` normal → `#707070` on hover   |
| Secondary Button Background | `#FAFAFA`                               |
| Primary Button Background | `#00C853` → `#23BE30` (on hover)        |

### 2.2 Typography

| Type     | Content                                          |
| -------- | ------------------------------------------------ |
| Font     | Sans-serif family (Manrope or Inter family)     |
| Size     | Base `14px`〜`18px`                              |
| Emphasis | Headings and numbers use `font-weight: 600~700` |
| Secondary | `font-weight: 400` or less + small size + gray |

## 3. Page Layout and Component Design

### 3.1 Common Header Structure
- Logo + Navigation (`DELEGATE` / `MINT` / `BUILD`)
- Flat layout, white background, no borders
- Unified placement and style across all pages

### 3.2 Footer Structure
- Links only for `DISCORD`, `GITHUB`, `POLICIES`
- Minimal and subtle placement

## 4. MINT Page Design Specifications

### 4.1 Page Components

#### Hero Area
- `100% Fair Launch` message
- AO supply status graph (curve) and issued supply numbers

#### Network Section
- Total amount of `FAIR LAUNCH DEPOSITS` and totals for each asset (sETH, DAI, USDS)
- "Your AO": AO balance after wallet connection + return predictions
- `Manage Delegations` for changing staking destinations

#### Deposits Section
Display each bridgeable asset (sETH / DAI / USDS) in card format:
- APY display (e.g., ≈8.3%)
- Native Yield
- Address display (with toggleable mini-modal)
- Deposit amount (Deposited) and predictions (30 days/1 year)
- Exchange rate (e.g., 1 USDS = 0.000432 AO)
- Green primary button (Deposit or Swap)

### 4.2 Operation Modal Design

#### Common Structure
| Feature              | Content                                                       |
| -------------------- | ------------------------------------------------------------- |
| Display Format       | Slide in from right (`position: fixed; right: 0`)            |
| Width                | Approximately 480px                                           |
| Background           | `#FFFFFF`                                                     |
| Header               | Asset name + address (shortened display) + Close (`×`)       |
| Navigation           | Tab format (Deposit / Withdraw) or step nav (during Swap)    |
| Input Fields         | Label + quantity + asset unit (right side)                   |
| Supplementary Text   | Lock time, mint ratio, audit information, etc. at bottom     |
| Action Button        | One button at the end. Active/inactive based on state        |

#### Deposit UI
```plaintext
[Header] Deposit [Asset]
 - Wallet Address: (0x...)
[Tab] Deposit | Withdraw

[Label] Deposited / Available
[Input] Quantity input field (asset unit on right side)

[Field] Arweave/AO Address (ReadOnly)

[Button] Deposit (green / inactive→active)

[Description]
- Mint ratio: 66.6%
- Grace period until acquisition: 24 hours
- Transfer unlock timing: After 15% issuance (scheduled February 2025)
- Audit logos
```

#### Withdraw UI (Locked State)
| State                    | Display Content                                                               |
| ------------------------ | ----------------------------------------------------------------------------- |
| Before Withdraw Available | Withdraw tab can be opened but input/execution unavailable                   |
| Warning Display          | `USDS is locked, you can withdraw in (15h:27m:17s)` (red text, dynamic countdown) |
| Withdraw Button          | Inactive and grayed out                                                       |

#### Swap UI Structure
| Step | Content                                                  |
| ---- | -------------------------------------------------------- |
| 1    | `Convert DAI to USDS` (step display + arrow UI)         |
| 2    | `Deposit USDS`                                           |
| 3    | `Complete` (likely toast display or screen transition)  |

## 5. DELEGATE Page Design Specifications

### 5.1 Page Layout Structure

| Section        | Content                                               |
| -------------- | ----------------------------------------------------- |
| Left Main      | List display of delegatable projects                  |
| Right Sidebar  | Current Allocation status summary and operation panel |

### 5.2 Project List (Left Panel)

| Item        | Content                                                                    |
| ----------- | -------------------------------------------------------------------------- |
| Row Layout  | Order / Token name / Address / Total delegation amount / Start date / Add button |
| Button Behavior | Pressing Add immediately reflects in right Allocation (with % change)     |
| Row Click   | Project detail dialog expands inline (Start/Unlock/Decay, etc.)           |

### 5.3 Add Button Behavior

| Operation     | Result                                                                                                              |
| ------------- | ------------------------------------------------------------------------------------------------------------------- |
| `Add` Press   | - Target project added to bottom of Allocation panel<br>- Initial allocation is +5%<br>- Warning if allocation exceeds 100% |
| `Added` State | Button changes to `Added` (with ✓)                                                                                 |
| `Remove` Operation | Delete with `-5%` button or uncheck (allocation also decreases)                                                    |

### 5.4 Allocation Panel Layout (Right Sidebar)

| Block        | Content                                              |
| ------------ | ---------------------------------------------------- |
| Pie Chart    | Visual display of allocation balance (ring chart)   |
| Allocation List | Distribution display of `$PI`, `$AO`, `$WNDR`, etc. (with % display) |
| Controls     | `-5% / +5%` buttons (increment style)               |
| Warning Display | "You are at 100%, you must remove some allocation to add more" |
| Final Confirmation | `Confirm Delegation Preferences` button for application confirmation |

## 6. Interaction Design (Interaction & UX)

### 6.1 Common Animation and UX Points

| UI Element     | Interaction                                           |
| -------------- | ----------------------------------------------------- |
| Modal Display  | Slide from right + background fade out (`ease-out`)  |
| Input Error    | Red border display (input field only)                |
| Tab Switch     | `border-bottom: 2px solid green` for active display  |
| Step UI        | Current step is green, others are gray (dynamic progression) |
| Countdown      | Real-time update in Withdraw tab (setInterval)       |
| Button         | Active/inactive controlled by `disabled`, clearly distinguished by color |

### 6.2 Button Styles

- **Primary** (green): `hover: slightly darker`, `border: same as bg`
- **Secondary** (white): `hover: gray background + darker border`
- **Disabled**: Grayed out, no cursor change

### 6.3 Wallet Mini-Modal

- `Dropdown` format, opens bottom-right
- 3 actions: `Copy`, `Explorer`, `Disconnect`
- High visibility but not overly assertive tone

## 7. State Management Design Patterns

### 7.1 Delegation State Model

```ts
type AllocationState = {
  totalPercent: number; // must be <= 100
  allocations: {
    token: string; // e.g. "$AO", "$WNDR"
    percent: number;
  }[];
};

function handleAdd(token: string) {
  if (totalPercent + 5 > 100) {
    showWarning("You are at 100%");
    return;
  }
  allocations.push({ token, percent: 5 });
  totalPercent += 5;
}

function handleAdjust(token: string, delta: number) {
  const target = allocations.find((a) => a.token === token);
  if (!target) return;
  target.percent += delta;
  totalPercent += delta;
}
```

### 7.2 Modal State-Based UI Changes

| State        | Change Content                                                    |
| ------------ | ----------------------------------------------------------------- |
| No Input     | `Deposit` button inactive (grayed out)                           |
| Input Error  | Input field border turns **red** (`border: 1px solid #F44336`)   |
| Valid Input  | `Deposit` button activates in green (`#00C853`)                  |
| Max Button   | Active only when available balance exists (placed top-right)     |

## 8. Reusable Design Patterns (Implementation Examples)

### 8.1 Primary Button

```tsx
<Button className="bg-green-600 hover:bg-green-700 border border-green-600 hover:border-green-700 text-white rounded-md px-6 py-3 transition-colors">
  <SwapIcon className="mr-2" />
  Deposit stETH
</Button>
```

### 8.2 Wallet Address Dropdown

```tsx
<DropdownMenu>
  <DropdownMenuTrigger>
    <AddressButton />
  </DropdownMenuTrigger>
  <DropdownMenuContent className="w-60">
    <DropdownMenuItem>Copy Address</DropdownMenuItem>
    <DropdownMenuItem>View in Explorer</DropdownMenuItem>
    <DropdownMenuItem>Disconnect</DropdownMenuItem>
  </DropdownMenuContent>
</DropdownMenu>
```

### 8.3 Deposit Modal Example

```tsx
<Dialog open={open}>
  <DialogContent className="w-[480px] fixed right-0 h-full bg-white shadow-xl p-6">
    <DialogHeader>
      <DialogTitle>Deposit stETH</DialogTitle>
      <DialogDescription className="text-sm text-gray-500">
        (0x3503...96e310)
      </DialogDescription>
    </DialogHeader>

    <Tabs defaultValue="deposit">
      <TabsList className="grid grid-cols-2 w-full border-b">
        <TabsTrigger value="deposit" className="border-b-2 border-green-600">
          Deposit
        </TabsTrigger>
        <TabsTrigger value="withdraw">Withdraw</TabsTrigger>
      </TabsList>

      <TabsContent value="deposit" className="space-y-4">
        <div className="flex items-center justify-between text-sm text-gray-600">
          <span>Deposited: 0</span>
          <span>Available: 0</span>
        </div>
        <Input className="border rounded-md" suffix="stETH" placeholder="0" />
        <Input disabled value="_hpY6p...OkuuQ" label="AO Address" />

        <Button disabled className="w-full bg-green-600 text-white rounded-md">
          Deposit
        </Button>
        <p className="text-xs text-gray-500">
          66.6% of AO tokens are minted... 24h delay
        </p>
        <AuditorLogos />
      </TabsContent>
    </Tabs>
  </DialogContent>
</Dialog>
```

## 9. Integrated Design Philosophy and Principles

### 9.1 AO Design Philosophy for Operation UI

- **Thoroughly Unified Structure**
  - Deposit / Swap / Withdraw / Delegate all follow the same layout principles

- **Quiet and Clear State Transitions**
  - Indicate with color, no excessive animations or UX

- **Proactive Display of Inactive UI**
  - Always show fields even when input is unavailable

- **Uncertainty Avoidance**
  - Clear indication of "when possible" like Withdraw timers

### 9.2 Delegation-Specific UX Features

- **Intuitive Percentage Operations**: -5/+5% UI is intuitive, making delegate ratio adjustments simple
- **Real-time Synchronization**: Add button → immediate reflection on right side. Very clear state management
- **Visual Constraints**: Pie chart + 100% limit rules clearly prevent over-allocation
- **Incremental UX**: Structure allowing step-by-step addition and adjustment per project

### 9.3 Core Values of Integrated Design

1. **Thorough Minimalism**: Achieve maximum effect with minimum necessary elements
2. **Predictability**: Users can always understand what will happen next
3. **Consistency**: Unified experience across all pages and components
4. **Function Priority**: Design prioritizing usability over appearance