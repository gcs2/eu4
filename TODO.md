# TODO

## In progress

- [ ] Icon — make `.ico` (Caravaggio Medusa or Mehmed II portrait), wire up tray + EXE

## Planned

- [ ] **SplitStack32** — one hotkey to split 32k → 16×2k  
  *Blocker: need to count how many province clicks reach Army B after A is fully split (9-item cycle). Run F6 twice as workaround.*

- [ ] **Verify age ability edicts** — confirm slot 9 coord (y=960) for Reformation / Absolutism / Revolutions ages and update the comments in script + README

- [ ] **Calibrate remaining diplo rows** — Outraged (675), Allies (760), Threatening (845) are computed, not WindowSpy-verified

## Ideas

- [ ] Sound or tray flash when a macro loop finishes
- [ ] Stack-size guard — stop siege loop early if fewer than SUBSTACK_COUNT units present
- [ ] STATE_COUNT in tray menu (toggle 5 / 8 / 11 rows)
- [ ] Ctrl+Shift+E to open State Edicts panel automatically (b → 9 → s) before the edict hotkeys

## Done

- [x] F8 — mass auto-siege all substacks
- [x] F7 — single-shot auto-siege
- [x] F6 — split 16k → 8×2k
- [x] F5 — split 16k then siege all 8
- [x] Ctrl+/ . , M N — Improve Relations (5 target rows, 7 diplomat clicks each)
- [x] Ctrl+E / Ctrl+A / Ctrl+- — state edicts (Encourage Dev / Age ability / No Edict)
- [x] Ctrl+D / Ctrl+Shift+D — Enable Divert Trade across subjects (all visible / one under cursor)
- [x] Tray menu — toggle substacks (8/16) and speed (fast/normal/slow) at runtime
- [x] Time currency — all sleeps as multiples of WAIT, tune once
- [x] build.ps1 — one-command compile to standalone EXE
- [x] README.md + KEYBINDINGS.md + RULES.md + BACKLOG.md
- [x] Kill hotkey fixed (Esc → Ctrl+Shift+F12, Esc fires constantly in EU4)
- [x] Click timing fixed (1× → 2× WAIT, was missing 3/8 units in siege loop)
