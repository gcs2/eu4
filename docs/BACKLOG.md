# BACKLOG — EU4 AHK Automation

---

## Planned

### SplitStack32 (32k → 16 × 2k, one hotkey)
Current workaround: press F6 twice (once per 16k half).  
To automate: after running the 16k pattern on Army A (8 substacks now in province), need to navigate to the intact 16k Army B and repeat. The exact click count to reach B from the final cursor position is **unknown** — depends on how EU4 cycles a 9-item province stack (8 × 2k + 1 × 16k).  
**Blocked on:** in-game testing to count how many clicks return to the 16k.  
Once click count is known, SplitStack32 = `s` → SplitStack16() → `click × N` → SplitStack16() on B, then tray → 16 substacks → F8.

---

## Ideas

- **Sound/visual feedback** — beep or tray flash when a loop completes.
- **Stack-size guard** — detect when fewer than SUBSTACK_COUNT units are present and stop early.
- **STATE_COUNT tray toggle** — add to tray menu alongside SUBSTACK_COUNT (e.g. 5 / 8 / 11 rows).

---

## Done

- **F8** — Mass auto-siege loop (all 8 substacks, fixed count).
- **F7** — Single-shot auto-siege (one press per unit, any stack size).
- **F6** — Split 16k army into 8 × 2k substacks (`s s s click s s click s click click s`).
- **F5** — Split 16k → 8 × 2k, then auto-siege all 8 (full one-key prep).
- **Ctrl+/** — Improve Relations → Neighbouring Countries.
- **Ctrl+.** — Improve Relations → Own Subject Countries.
- **Ctrl+,** — Improve Relations → Outraged Countries.
- **Ctrl+M** — Improve Relations → Allies.
- **Ctrl+N** — Improve Relations → Threatening Countries.
- Coordinate table with `(*)`-verified baseline at 4K + UI 1.3, computed fallbacks for 1440p.
- `SiegeButtonCoords()` auto-scales from baseline; `UI_SCALE` is single-line user config.
- `build.ps1` compiles to standalone `.exe` via `Ahk2Exe` + AHK v2 runtime.
- Kill hotkey changed from `Esc` → `Ctrl+Shift+F12` (Esc was silently killing script mid-EU4-session).
- **Ctrl+E** — Set all visible states → Encourage Development.
- **Ctrl+A** — Set all visible states → Age ability edict (9th slot).
- **Ctrl+-** — Set all visible states → No Edict.
- Renamed file to `eu4_standard_pack.ahk`; added `docs/KEYBINDINGS.md` visualization.
- **Tray menu** — right-click taskbar icon to toggle `SUBSTACK_COUNT` (8/16) and `WAIT` speed (fast/normal/slow) without recompiling. Brief tooltip overlay confirms each change.
