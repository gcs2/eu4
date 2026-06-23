# EU4 Standard Macro Pack — Keybinding Map

## Zone strategy

Modifier pattern = category. Learn the zone, then fill in the keys.

| Zone | Modifier | Category |
|------|----------|----------|
| F-row | (none) | **Military** — fast, no hand reposition |
| Ctrl + symbol | `^` + `. , / m n` | **Diplomacy** — right-side cluster |
| Ctrl + letter | `^` + letter | **State / Admin** |
| Ctrl+Shift+F12 | `^+F12` | **Kill script** |

---

## Visual layout

```
 ┌──────┐  ┌──────┬──────┬──────┬──────┐  ┌──────┬──────┬──────┬──────┐  ┌──────┬──────┬──────┐
 │  Esc │  │  F1  │  F2  │  F3  │  F4  │  │  F5  │  F6  │  F7  │  F8  │  │  F9  │ F10  │ F11  │
 │      │  │      │      │      │      │  │  ⚔+🗺 │  🗺  │  ⚔  │ ⚔⚔⚔ │  │      │      │      │
 └──────┘  └──────┴──────┴──────┴──────┘  └──────┴──────┴──────┴──────┘  └──────┴──────┴──────┘
              [    unbound / EU4 native   ]  [        MILITARY ZONE       ]

 ┌──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┐
 │  `   │  1   │  2   │  3   │  4   │  5   │  6   │  7   │  8   │  9   │  0   │  -   │  =   │
 │      │      │      │      │      │      │      │      │      │      │      │ C+-  │      │
 └──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┘
                                                                               No Edict

 ┌──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┐
 │  Tab │  Q   │  W   │  E   │  R   │  T   │  Y   │  U   │  I   │  O   │  P   │  [   │  ]   │
 │      │      │      │ C+E  │      │      │      │      │      │      │      │      │      │
 └──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┘
                              Enc.Dev

 ┌──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┐
 │ Caps │  A   │  S   │  D   │  F   │  G   │  H   │  J   │  K   │  L   │  ;   │  '   │
 │      │ C+A  │      │      │      │      │      │      │      │      │      │      │
 └──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┘
          Age Abil.

 ┌──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┐
 │ Shift│  Z   │  X   │  C   │  V   │  B   │  N   │  M   │  ,   │  .   │  /   │
 │      │      │      │      │      │      │ C+N  │ C+M  │ C+,  │ C+.  │ C+/  │
 └──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┘
                                             Threat  Allies Outrag. Subj.  Nbrs.
                                             [              DIPLOMACY ZONE     ]
```

**Legend:** `C+` = Ctrl,  `C++` = Ctrl+Shift

---

## Full binding reference

### Military (F-row, no modifier)

| Key | Action |
|-----|--------|
| F5  | Split 16k → 8×2k **then** mass auto-siege all 8 |
| F6  | Split 16k → 8×2k only |
| F7  | Single-shot auto-siege (one unit per press, any stack size) |
| F8  | Mass auto-siege all `SUBSTACK_COUNT` units (tray: 8 for 16k / 16 for 32k) |

### State Edicts (Ctrl + letter, panel open first)

| Key | Action |
|-----|--------|
| Ctrl+E | Set all visible states → Encourage Development |
| Ctrl+A | Set all visible states → Age ability edict (9th slot, changes per age) |
| Ctrl+- | Set all visible states → No Edict |

> Open panel first: `b → 9 → s`. Manually scroll state list to the rows you want. Max 11 rows visible.

### Diplomacy — Improve Relations (Ctrl + symbol, clean screen)

| Key | Action |
|-----|--------|
| Ctrl+/ | Improve Relations → Neighbouring Countries |
| Ctrl+. | Improve Relations → Own Subject Countries |
| Ctrl+, | Improve Relations → Outraged Countries |
| Ctrl+M | Improve Relations → Allies |
| Ctrl+N | Improve Relations → Threatening Countries |

> Opens panel automatically: `b → 0 → a`. Clicks 7 times (all diplomats).

### Tray menu (right-click taskbar icon)

| Setting | Options |
|---------|---------|
| Substacks | **8** (16k army) / 16 (32k army) — changes F8 loop count |
| Speed | Fast (WAIT=25ms) / **Normal (50ms)** / Slow (100ms) — scales all timings |

Brief tooltip overlay confirms each change. Works in fullscreen EU4.

### Utility

| Key | Action |
|-----|--------|
| Ctrl+Shift+F12 | Kill script immediately |

---

## Open slots (good candidates for future macros)

| Zone | Available keys |
|------|---------------|
| Military (F-row) | F9, F10, F11 |
| State/Admin (Ctrl+letter) | C+R, C+T, C+D, C+F, C+G, C+H, C+J, C+K, C+L |
| Diplomacy (Ctrl+symbol) | C+; C+' C+[ C+] |
| Ctrl+Shift (utility) | C++E, C++A, C++R … |
