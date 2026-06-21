# RULES.md — EU4 Mass Auto-Siege AHK Project

Rules, invariants, and hard-won learnings for this codebase. Update on every discovery.

---

## 1. AHK Version

- **Use AutoHotkey v2** (not v1). Syntax is incompatible; v2 is the current release.
- All scripts must start with `#Requires AutoHotkey v2.0` to crash-fast on wrong version.
- v2 differences from v1: no bare commands (use functions), `:=` everywhere, `%var%` replaced by `var`, `MsgBox` takes parens, etc.

## 2. Coordinate System

- **Always set `CoordMode "Mouse", "Screen"`** at script top. Without it, coords are relative to the active window client area — unreliable across game sessions that may reposition the window.
- **User's screen resolution: 3840 × 2160 (4K). EU4 UI Scale: 1.3.**
- **Confirmed: "Manage Autonomous Sieging" button = (600, 900) at 4K + UI Scale 1.3.** This is the calibrated baseline all other values are derived from.
- If EU4 UI scale changes (Options → UI Scale), update `UI_SCALE` in the script — coords are recomputed automatically.
- Changing resolution also recomputes automatically via `A_ScreenWidth` / `A_ScreenHeight`.

### Resolution scaling reference

- **User's EU4 UI Scale: 1.3** (confirmed). This scales all panel elements.
- The script auto-detects resolution via `A_ScreenWidth`/`A_ScreenHeight` and accepts `UI_SCALE` as a user constant.
- **Scaling formula** (applied automatically in `SiegeButtonCoords()`):
  ```
  new_x = round(600 * (target_width  / 3840) * (target_ui_scale / 1.3))
  new_y = round(900 * (target_height / 2160) * (target_ui_scale / 1.3))
  ```

### Coordinate matrix — Manage Autonomous Sieging button

`(*)` = verified with WindowSpy. `(c)` = computed from baseline.

| Resolution       | UI Scale | X   | Y   | Status |
|------------------|----------|-----|-----|--------|
| 3840×2160 (4K)   | 1.3      | 600 | 900 | *      |
| 3840×2160 (4K)   | 1.0      | 462 | 692 | c      |
| 2560×1440 (1440p)| 1.3      | 400 | 600 | c      |
| 2560×1440 (1440p)| 1.0      | 308 | 462 | c      |

> Computed entries are mathematically derived — verify with WindowSpy before relying on them. Add verified entries to `BTN_COORDS` in `eu4_autoseige.ahk` when confirmed.

## 3. Finding Pixel Coordinates — WindowSpy

WindowSpy ships with every AHK install. To use it:

```
C:\Program Files\AutoHotkey\WindowSpy.ahk
```

Run it with AHK. Hover over any pixel and it displays:
- `Mouse: X Y` — screen coords (use these)
- `Color` — hex RGB under cursor
- `Window` — title and class of window under cursor

**Workflow for calibrating EU4 button coords:**
1. Launch EU4.
2. Select a unit → the army panel appears in the bottom-left.
3. Hover over **Manage Autonomous Sieging** button until tooltip appears (as in `tooltip.png`).
4. Read the `Mouse: X Y` values from WindowSpy — those are `SIEGE_BTN_X` / `SIEGE_BTN_Y`.
5. Update `eu4_autoseige.ahk` config section.

## 4. Mouse Movement

- Use `MouseMove x, y, 0` — speed `0` means **instant** (no animation delay, no OS acceleration artifacts).
- Do NOT use `SendMode "Play"` for mouse in EU4 — it has quirks with some games. Use **`SendMode "Event"`** (default).
- `MouseGetPos &x, &y` captures current cursor position into variables `x` and `y`.

## 5. Time Currency

All sleeps are expressed as multiples of a single base unit `WAIT` (default: 50ms).  
Tune `WAIT` once — every timing in the script scales proportionally.

| Expression   | ms (at WAIT=50) | When to use                              |
|--------------|-----------------|------------------------------------------|
| `WAIT`       | 50ms  (1×)      | Between key sends; after mouse moves     |
| `WAIT * 2`   | 100ms (2×)      | After clicks — EU4 needs registration time |
| `WAIT * 4`   | 200ms (4×)      | UI panel open / tab switch transitions   |
| `WAIT * 6`   | 300ms (6×)      | Settle pause after a batch of operations |

- Clicks reliably need **2×** — 1× was causing missed inputs in the split sequence.
- OS timer granularity on Windows is ~15.6ms, so 50ms rounds up cleanly.
- `Sleep 0` does NOT actually sleep — use at least `Sleep 10` for a real yield.

## 6. EU4-Specific: Stack Cycling

- When multiple armies share a province, clicking the province cycles through stacked units one at a time.
- The army panel (bottom-left) updates to show the newly selected unit.
- The "Manage Autonomous Sieging" button position in the panel is **fixed** regardless of which subunit is selected — it's always at the same panel-relative location.
- **Confirmed unit count: 8 substacks of 2k each** (from a 16k pre-split stack). The loop runs exactly 8 iterations.
- On the final iteration, skip the "click to cycle" step — there is no 9th unit to cycle to.

## 7. Compilation to EXE (Ahk2Exe)

- Ahk2Exe ships with AHK. Default path:
  ```
  C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe
  ```
- Command to compile:
  ```powershell
  & "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in eu4_autoseige.ahk /out eu4_autoseige.exe
  ```
- The resulting `.exe` is self-contained — no AHK install needed on target machine to run it.
- Script directives (e.g., `; @Ahk2Exe-ConsoleApp`) can embed metadata or change compile behaviour.
- See `build.ps1` for the one-command compile workflow.

## 8. Safety / Kill Switch

- **Every AHK automation script MUST have an emergency kill hotkey.**
- **NEVER use bare `Esc` as the kill switch in EU4.** Esc fires constantly in-game (closing panels, cancelling actions, backing out of menus). It will silently kill the script mid-session.
- Current kill hotkey: `^+F12` (Ctrl+Shift+F12) — safe, never used by EU4.
- All global config vars must be declared with `global` at the top level in AHK v2, not just inside functions. Otherwise function-scope `global` declarations can silently shadow them.

## 9. EU4 Stack Split Mechanic

- **`S` key** = split the currently selected army in half.
- After pressing S on a 16k: creates Army A (8k, **shown in panel**) and Army B (8k, **not shown**).
- **Clicking the province** (at the saved mouse position) cycles to Army B.
- You can chain S presses without clicking to go depth-first into Army A's sub-splits.
- Full split of 16k → 8 × 2k requires **7 S presses** (binary tree: 1 + 2 + 4) and **4 clicks** to navigate between branches.
- Pattern (confirmed by user): `s s s click s s click s click click s`
- Province state builds depth-first: after `s s` → [4*, 4, 8]; after `s s s` → [2*, 2, 4, 8]
- `click` jumps to the back of the cycle (Army B = the 8k that hasn't been touched yet)
- Automation: `Send "s"` for key presses, `Click` at saved mouse position for province cycling
- Mouse never needs to move during the split — stays at the province/stack position throughout.

## 10. What We Learned From Initial Research (June 2026)

- `SendMode "Play"` works in more games for keyboard but can behave oddly for mouse — prefer `"Event"` for mouse clicks in EU4.
- `Click` in AHK v2 clicks at current cursor position by default; `Click x, y` moves and clicks in one call.
- `Loop+Sleep` is simpler and more predictable than `SetTimer` for sequential fixed-count automation like this.
- `MouseMove` with speed=0 + explicit `Sleep SLEEP_MS` after gives full control over timing.
- Image-based detection (`ImageSearch`) is unnecessary here — button position is fixed and reliable.

---

*Update this file when new constraints are discovered, timing is tuned, or EU4 updates shift UI positions.*
