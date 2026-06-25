# EU4 Standard Macro Pack

AutoHotkey v2 macro suite for Europa Universalis IV. Automates sieges, army splitting, diplomat assignment, and state edicts. Built for **4K (3840×2160) at UI Scale 1.3** with fallback scaling for other resolutions.

---

## Requirements

- [AutoHotkey v2](https://www.autohotkey.com/) installed
- EU4 running in the foreground when macros fire
- Calibrated for **4K + UI Scale 1.3** — see [Calibration](#calibration) to adjust

---

## Quick start

**Run from source** (no compile needed):
```
Double-click eu4_standard_pack.ahk
```

**Or run the compiled EXE** (built with `.\build.ps1`):
```
Double-click eu4_standard_pack.exe
```

The script sits in the system tray. Right-click the tray icon to change settings or exit.

---

## Hotkeys

### Military — F-row

| Key | Action | Before pressing |
|-----|--------|-----------------|
| **F5** | Split 16k → 8×2k, then siege all 8 | Select the 16k army, cursor on province |
| **F6** | Split 16k → 8×2k | Select the 16k army, cursor on province |
| **F7** | Single-shot siege (one unit per press) | Select unit, cursor on province |
| **F8** | Mass siege all `SUBSTACK_COUNT` units | Cursor on province with substacks |

> **32k armies:** set tray → Substacks: 16, run F6 on each 16k half, then F8.

### Diplomacy — Ctrl + symbol

All open the Improve Relations panel automatically (`b → 0 → a`) and click the target row 7 times (all diplomats). Requires a clean screen.

| Key | Target |
|-----|--------|
| **Ctrl+/** | Neighbouring Countries |
| **Ctrl+.** | Own Subject Countries |
| **Ctrl+,** | Outraged Countries |
| **Ctrl+M** | Allies |
| **Ctrl+N** | Threatening Countries |

### State Edicts — Ctrl + letter

Open the State Edicts panel first (`b → 9 → s`), manually scroll to the states you want, then press the hotkey. Applies to all visible rows (up to 11).

| Key | Edict |
|-----|-------|
| **Ctrl+E** | Encourage Development |
| **Ctrl+A** | Age ability edict (slot 9 — changes each age) |
| **Ctrl+-** | No Edict |

### Utility

| Key | Action |
|-----|--------|
| **Ctrl+Shift+F12** | Kill script immediately |

---

## Tray menu

Right-click the taskbar icon (works in fullscreen EU4):

| Setting | Options | Default |
|---------|---------|---------|
| Substacks | 8 (16k army) / **16 (32k army)** | 8 |
| Speed | Fast 25ms / **Normal 50ms** / Slow 100ms | Normal |

A tooltip flashes on screen when a setting changes.

---

## Calibration

Coordinates are verified for **4K + UI Scale 1.3**. For other setups:

1. Open `eu4_standard_pack.ahk`
2. Change `UI_SCALE` to match EU4 → Options → UI Scale
3. Resolution is detected automatically via `A_ScreenWidth` / `A_ScreenHeight`
4. Use **WindowSpy** (`C:\Program Files\AutoHotkey\WindowSpy.ahk`) to verify button positions
5. Add verified coords to `BTN_COORDS` in the script

### Known verified coordinates (4K + UI 1.3)

| Element | X | Y |
|---------|---|---|
| Manage Autonomous Sieging button | 600 | 900 |
| Improve Relations — Neighbouring Countries | 155 | 505 |
| State Edict dropdown, first row | 500 | 380 |
| State Edict dropdown option column | 1000 | — |

---

## Building from source

Requires [Ahk2Exe](https://github.com/AutoHotkey/Ahk2Exe/releases) — drop `Ahk2Exe.exe` next to `build.ps1`.

```powershell
.\build.ps1
```

Output: `eu4_standard_pack.exe` (self-contained, no AHK install needed to run).

---

## File map

```
eu4_standard_pack.ahk   main script
eu4_standard_pack.exe   compiled binary (git-ignored, build with .\build.ps1)
build.ps1               compile script
TODO.md                 planned work and ideas
docs/
  KEYBINDINGS.md        visual keyboard layout + zone strategy
  BACKLOG.md            detailed notes on blocked/planned features
  RULES.md              invariants, hard-won learnings, coordinate reference
  PLAN.md               setup guide and coord calibration notes
```

---

## Age ability edicts

The age ability edict (Ctrl+A) is always **slot 9** in the dropdown — the coordinate stays fixed, the edict itself changes each age:

| Age | Edict |
|-----|-------|
| Age of Discovery | Feudal Taxes Edict |
| Age of Reformation | *(update comment in script when confirmed)* |
| Age of Absolutism | *(update comment in script when confirmed)* |
| Age of Revolutions | *(update comment in script when confirmed)* |
