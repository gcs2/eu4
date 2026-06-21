# BACKLOG — EU4 AHK Automation

---

## Planned

### State Edicts automation
From the States panel (b → [States tab] → State Edicts sub-tab), set edicts across all states in one pass.  
Screenshot reference: `production to States to State Edicts.png`  
**Blocked on:** navigation key sequence to reach State Edicts, and whether edicts are set via a dropdown click or a fixed coord per row.

---

## Ideas

- **Variable substack count** — prompt or read from UI overlay so F8 works for non-8 splits.
- **Sound/visual feedback** — beep or tray flash when a loop completes.
- **Stack-size guard** — detect when fewer than SUBSTACK_COUNT units are present and stop early.
- **Rename eu4_autoseige.ahk** — file scope has grown beyond siege; consider `eu4_macros.ahk`.

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
