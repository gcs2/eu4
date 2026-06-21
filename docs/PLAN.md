# PLAN.md — EU4 Mass Auto-Siege via AutoHotKey

**Goal:** One hotkey press autonomously clicks "Manage Autonomous Sieging" for all 8 substacks in a pre-split 16k army (8 × 2k), each click cycling through the stack.

---

## Phase 0: Prerequisites

- [ ] Install **AutoHotkey v2** from https://www.autohotkey.com/download/
  - Installs `AutoHotkey64.exe` and ships `WindowSpy.ahk` + `Compiler\Ahk2Exe.exe`
- [ ] Confirm install path: `C:\Program Files\AutoHotkey\`

---

## Phase 1: Find Button Coordinates (WindowSpy)

This is the only manual calibration step. Do it once; results go in `eu4_autoseige.ahk`.

1. Launch EU4 in **fullscreen** (or windowed-fullscreen) at **3840 × 2160**.
2. Select any army unit so the army command panel appears in the bottom-left.
3. Run `WindowSpy.ahk` (double-click it with AHK installed, or right-click → Run with AHK).
4. In EU4, hover over the **Manage Autonomous Sieging** button until the tooltip appears (see `tooltip.png`).
5. Read `Mouse: X Y` from WindowSpy — record these as `SIEGE_BTN_X` and `SIEGE_BTN_Y`.
6. Open `eu4_autoseige.ahk` and update:
   ```
   SIEGE_BTN_X := ????    ; replace with WindowSpy reading
   SIEGE_BTN_Y := ????    ; replace with WindowSpy reading
   ```

### Confirmed coordinate (4K + UI Scale 1.3)

| UI Element               | X   | Y   | Status              |
|--------------------------|-----|-----|---------------------|
| Manage Autonomous Siege  | 600 | 900 | * verified WindowSpy|

The script stores these in a `BTN_COORDS` map keyed by `"WxH@scale"` and auto-selects
the right entry based on detected resolution + configured `UI_SCALE`. If your combo is
not in the table it computes via the scaling formula — see `docs/RULES.md §2` for the full matrix.

---

## Phase 2: Configure and Run the Script

1. Open `eu4_autoseige.ahk` in a text editor.
2. Fill in `SIEGE_BTN_X` and `SIEGE_BTN_Y` from Phase 1.
3. Optionally adjust `SLEEP_MS` (default: 50 ms) if clicks are missed or too slow.
4. Double-click `eu4_autoseige.ahk` to run it with AHK (tray icon appears).
5. In EU4:
   - Split your army into 8 × 2k substacks and gather them in the siege province.
   - Click on the province to select the first substack.
   - Position the army panel to ensure the Manage Autonomous Sieging button is visible.
   - Press the hotkey (default: `F8`) — the script loops 8 times automatically.
6. Press `Esc` at any time to abort.

---

## Phase 3: Compile to Standalone EXE

Run the build script from the project root:

```powershell
.\build.ps1
```

This invokes `Ahk2Exe.exe` and produces `eu4_autoseige.exe` — no AHK install needed to run the binary.

Alternatively, compile manually:
```powershell
& "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in eu4_autoseige.ahk /out eu4_autoseige.exe
```

---

## Phase 4: Tune and Iterate

| Symptom                        | Fix                                             |
|-------------------------------|-------------------------------------------------|
| Clicks are missed              | Increase `SLEEP_MS` (try 100 ms)               |
| Animation too slow             | Decrease `SLEEP_MS` (try 30 ms)                |
| Wrong unit selected at start   | Click the first substack manually before hotkey |
| Button moves after EU4 update  | Re-run WindowSpy, update coordinates           |
| 4K → 1440p: coords wrong       | See scaling formula in `RULES.md §2`           |

---

## File Map

```
eu_strat/
├── eu4_autoseige.ahk     ← main script (edit config constants here)
├── eu4_autoseige.exe     ← compiled binary (produced by build.ps1)
├── build.ps1             ← one-command compile
├── map_dimensions.png    ← reference: 4K game screenshot
├── tooltip.png           ← reference: Manage Autonomous Sieging tooltip
└── docs/
    ├── PLAN.md           ← this file
    ├── RULES.md          ← learnings, invariants, calibration notes
    └── BACKLOG.md        ← feature requests and ideas
```

---

## Design Decisions

**Why `Loop+Sleep` instead of `SetTimer`?**
This is a fixed-count sequential operation (8 clicks in order). `SetTimer` is for asynchronous recurring tasks. `Loop` with explicit `Sleep` between steps gives deterministic ordering and is easier to reason about.

**Why save mouse position once (not per-iteration)?**
The stack is in one fixed province. All 8 substacks live at the same pixel. Clicking the pixel cycles through them. We record the position once at hotkey fire and reuse it every iteration.

**Why `MouseMove x, y, 0` (speed 0)?**
Speed 0 = instant teleport. This avoids the OS mouse-acceleration easing that can cause intermediate pixels to be briefly hovered, which could accidentally interact with map elements between the stack and the siege button.
