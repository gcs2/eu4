#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================
; EU4 Standard Macro Pack
; ============================================================

; --- Time currency ---
; All sleeps are multiples of WAIT. Tune once, everything scales.
;   1x WAIT =  50ms  small pause (between key sends)
;   2x WAIT = 100ms  medium pause (after clicks)
;   4x WAIT = 200ms  UI transition (panel open / tab switch)
;   6x WAIT = 300ms  settle pause (after a batch of operations)
global WAIT := 50

; --- General config ---
global UI_SCALE       := 1.3   ; EU4 Options -> UI Scale
global SUBSTACK_COUNT := 8     ; F8 mass siege loop (tray-toggleable: 8 or 16)
global DIPLOMAT_COUNT := 7     ; clicks per Improve Relations hotkey

; --- Hotkeys ---
; AHK prefixes: ^ = Ctrl  ! = Alt  + = Shift
; Do NOT use bare Esc - EU4 fires it constantly and kills the script
global HK_MASS_SIEGE   := "F8"     ; siege all SUBSTACK_COUNT units
global HK_SINGLE_SIEGE := "F7"     ; single unit per press (any stack size)
global HK_SPLIT_16     := "F6"     ; split 16k -> 8 x 2k
global HK_KILL         := "^+F12"  ; Ctrl+Shift+F12 - terminate script

; ============================================================
; Siege button coordinates  (* = WindowSpy verified, c = computed)
; ============================================================
global BTN_COORDS := Map(
    "3840x2160@1.3", {x: 600, y: 900},  ; * 4K    / UI 1.3 - calibrated
    "3840x2160@1.0", {x: 462, y: 692},  ; c 4K    / UI 1.0
    "2560x1440@1.3", {x: 400, y: 600},  ; c 1440p / UI 1.3
    "2560x1440@1.0", {x: 308, y: 462}   ; c 1440p / UI 1.0
)
global BASELINE := {w: 3840, h: 2160, scale: 1.3, x: 600, y: 900}

SiegeButtonCoords(res_w, res_h, ui_scale) {
    key := res_w "x" res_h "@" ui_scale
    if BTN_COORDS.Has(key)
        return BTN_COORDS[key]
    return {
        x: Round(BASELINE.x * (res_w  / BASELINE.w) * (ui_scale / BASELINE.scale)),
        y: Round(BASELINE.y * (res_h  / BASELINE.h) * (ui_scale / BASELINE.scale))
    }
}

global SIEGE_BTN_X := 0
global SIEGE_BTN_Y := 0
_btn        := SiegeButtonCoords(A_ScreenWidth, A_ScreenHeight, UI_SCALE)
SIEGE_BTN_X := _btn.x
SIEGE_BTN_Y := _btn.y

; ============================================================
; Diplomacy -> Improve Relations  (* = verified, 4K + UI 1.3)
; Navigation: b -> 0 -> a  (from clean screen)
; ============================================================
global DIPLO_X           := 155
global DIPLO_Y_NEIGHBORS := 505  ; * Neighbouring Countries
global DIPLO_Y_SUBJECTS  := 590  ; * Own Subject Countries (+85)
global DIPLO_Y_OUTRAGED  := 675  ;   Outraged Countries    (+85)
global DIPLO_Y_ALLIES    := 760  ;   Allies                (+85)
global DIPLO_Y_THREAT    := 845  ;   Threatening Countries (+85)

; ============================================================
; State Edicts  (* = verified, 4K + UI 1.3)
; Navigation: b -> 9 -> s  (from clean screen)
; Panel must be open; user manually scrolls state list first.
; Max 11 rows visible (STATE_COUNT). Rows: x=500, y=380, step=44px.
; Dropdown options: x=1000, y starts 400, step=70px.
;   1. Advancement Effort    400
;   2. Centralization Effort 470
;   3. Defensive Edict       540
;   4. Encourage Development 610  <- holy grail
;   5. Feudal De Jure Law    680
;   6. Increase Enlistment   750
;   7. Protect Trade         820
;   8. Enforce Religious     890
;   9. Age ability edict     960  <- slot 9, changes each age
;      (Age of Discovery = Feudal Taxes Edict)
;   [WheelDown x1] No Edict  960
; ============================================================
global STATE_COUNT        := 11
global EDICT_BTN_X        := 500
global EDICT_BTN_Y_FIRST  := 380
global EDICT_ROW_H        := 44
global EDICT_OPT_X        := 1000
global EDICT_Y_ENCOURAGE   := 610
global EDICT_Y_AGE_ABILITY := 960  ; slot 9 — changes each age, coord stays the same
global EDICT_Y_NO_EDICT    := 960  ; after 1x WheelDown

CoordMode "Mouse", "Screen"
SendMode "Event"

; ============================================================
; Tray menu — toggle key settings without recompiling
; Right-click the taskbar icon (works in fullscreen EU4)
; ============================================================

; Label strings (must match exactly for Check/Uncheck calls)
global TL_S8  := "Substacks:  8  (16k army / F8)"
global TL_S16 := "Substacks: 16  (32k army / F8)"
global TL_WF  := "Speed: Fast   — WAIT=25ms"
global TL_WN  := "Speed: Normal — WAIT=50ms"
global TL_WS  := "Speed: Slow   — WAIT=100ms"

A_TrayMenu.Delete()
A_TrayMenu.Add(TL_S8,  TraySetS8)
A_TrayMenu.Add(TL_S16, TraySetS16)
A_TrayMenu.Check(TL_S8)
A_TrayMenu.Add()
A_TrayMenu.Add(TL_WF, TraySetWF)
A_TrayMenu.Add(TL_WN, TraySetWN)
A_TrayMenu.Add(TL_WS, TraySetWS)
A_TrayMenu.Check(TL_WN)
A_TrayMenu.Add()
A_TrayMenu.Add("Exit", (*) => ExitApp())

; Brief tooltip overlay so you see the change without looking at the tray
Notify(msg) {
    ToolTip msg
    SetTimer () => ToolTip(), -1500
}

TraySetS8(*) {
    global SUBSTACK_COUNT, TL_S8, TL_S16
    SUBSTACK_COUNT := 8
    A_TrayMenu.Uncheck(TL_S16)
    A_TrayMenu.Check(TL_S8)
    Notify("Substacks: 8  (16k army)")
}
TraySetS16(*) {
    global SUBSTACK_COUNT, TL_S8, TL_S16
    SUBSTACK_COUNT := 16
    A_TrayMenu.Uncheck(TL_S8)
    A_TrayMenu.Check(TL_S16)
    Notify("Substacks: 16  (32k army)")
}
TraySetWF(*) {
    global WAIT, TL_WF, TL_WN, TL_WS
    WAIT := 25
    A_TrayMenu.Uncheck(TL_WN), A_TrayMenu.Uncheck(TL_WS)
    A_TrayMenu.Check(TL_WF)
    Notify("Speed: Fast  (WAIT=25ms)")
}
TraySetWN(*) {
    global WAIT, TL_WF, TL_WN, TL_WS
    WAIT := 50
    A_TrayMenu.Uncheck(TL_WF), A_TrayMenu.Uncheck(TL_WS)
    A_TrayMenu.Check(TL_WN)
    Notify("Speed: Normal  (WAIT=50ms)")
}
TraySetWS(*) {
    global WAIT, TL_WF, TL_WN, TL_WS
    WAIT := 100
    A_TrayMenu.Uncheck(TL_WF), A_TrayMenu.Uncheck(TL_WN)
    A_TrayMenu.Check(TL_WS)
    Notify("Speed: Slow  (WAIT=100ms)")
}

; ============================================================
; F8 - Mass Auto-Siege  (SUBSTACK_COUNT set via tray)
; ============================================================
MassAutoSiege() {
    global SIEGE_BTN_X, SIEGE_BTN_Y, WAIT, SUBSTACK_COUNT
    MouseGetPos &stackX, &stackY

    Loop SUBSTACK_COUNT {
        MouseMove SIEGE_BTN_X, SIEGE_BTN_Y, 0
        Sleep WAIT
        Click
        Sleep WAIT * 2
        MouseMove stackX, stackY, 0
        Sleep WAIT
        if A_Index < SUBSTACK_COUNT {
            Click
            Sleep WAIT * 2
        }
    }
}

; ============================================================
; F7 - Single-Shot Auto-Siege (one press = one unit)
; ============================================================
SingleAutoSiege() {
    global SIEGE_BTN_X, SIEGE_BTN_Y, WAIT
    MouseGetPos &origX, &origY
    MouseMove SIEGE_BTN_X, SIEGE_BTN_Y, 0
    Sleep WAIT
    Click
    Sleep WAIT
    MouseMove origX, origY, 0
    Sleep WAIT
    Click
    Sleep WAIT
}

; ============================================================
; F6 - Split 16k army into 8 x 2k substacks
; Pattern: s s s click  s s click  s click click  s
; For 32k: run F6 on each 16k half separately (tray -> 16 substacks for F8)
; ============================================================
SplitStack16() {
    global WAIT
    Send "s"
    Sleep WAIT
    Send "s"
    Sleep WAIT
    Send "s"
    Sleep WAIT
    Click
    Sleep WAIT * 2
    Send "s"
    Sleep WAIT
    Send "s"
    Sleep WAIT
    Click
    Sleep WAIT * 2
    Send "s"
    Sleep WAIT
    Click
    Sleep WAIT * 2
    Click
    Sleep WAIT * 2
    Send "s"
    Sleep WAIT
}

; ============================================================
; F5 - Split 16k -> 8 x 2k, then auto-siege all SUBSTACK_COUNT
; ============================================================
SplitThenSiege() {
    SplitStack16()
    Sleep WAIT * 6
    MassAutoSiege()
}

; ============================================================
; Diplomacy - Improve Relations
; ============================================================
ImproveRelations(y_coord) {
    global WAIT, DIPLO_X, DIPLOMAT_COUNT
    Send "b"
    Sleep WAIT * 4
    Send "0"
    Sleep WAIT * 4
    Send "a"
    Sleep WAIT * 4
    MouseMove DIPLO_X, y_coord, 0
    Sleep WAIT
    Loop DIPLOMAT_COUNT {
        Click
        Sleep WAIT
    }
}

; ============================================================
; State Edicts - set edict for all STATE_COUNT visible rows
; ============================================================
SetAllEdicts(edict_y, needs_scroll := false) {
    global WAIT, STATE_COUNT, EDICT_BTN_X, EDICT_BTN_Y_FIRST, EDICT_ROW_H, EDICT_OPT_X

    Loop STATE_COUNT {
        btn_y := EDICT_BTN_Y_FIRST + (A_Index - 1) * EDICT_ROW_H
        MouseMove EDICT_BTN_X, btn_y, 0
        Sleep WAIT
        Click
        Sleep WAIT * 2

        if needs_scroll {
            MouseMove EDICT_OPT_X, 680, 0
            Sleep WAIT
            Send "{WheelDown}"
            Sleep WAIT
        }

        MouseMove EDICT_OPT_X, edict_y, 0
        Sleep WAIT
        Click
        Sleep WAIT
        Send "{Enter}"
        Sleep WAIT * 2
    }
}

; ============================================================
; Hotkey bindings
; ============================================================

; --- Military ---
Hotkey HK_MASS_SIEGE,   (*) => MassAutoSiege()
Hotkey HK_SINGLE_SIEGE, (*) => SingleAutoSiege()
Hotkey HK_SPLIT_16,     (*) => SplitStack16()
Hotkey "F5",            (*) => SplitThenSiege()

; --- Diplomacy: Improve Relations ---
Hotkey "^/", (*) => ImproveRelations(DIPLO_Y_NEIGHBORS)  ; Ctrl+/  Neighbouring
Hotkey "^.", (*) => ImproveRelations(DIPLO_Y_SUBJECTS)   ; Ctrl+.  Own Subjects
Hotkey "^,", (*) => ImproveRelations(DIPLO_Y_OUTRAGED)   ; Ctrl+,  Outraged
Hotkey "^m", (*) => ImproveRelations(DIPLO_Y_ALLIES)     ; Ctrl+M  Allies
Hotkey "^n", (*) => ImproveRelations(DIPLO_Y_THREAT)     ; Ctrl+N  Threatening

; --- State Edicts (panel open, state list scrolled to target rows) ---
Hotkey "^e", (*) => SetAllEdicts(EDICT_Y_ENCOURAGE)           ; Ctrl+E  Encourage Dev
Hotkey "^-", (*) => SetAllEdicts(EDICT_Y_NO_EDICT, true)      ; Ctrl+-  No Edict
Hotkey "^a", (*) => SetAllEdicts(EDICT_Y_AGE_ABILITY)         ; Ctrl+A  Age ability

; --- Kill ---
Hotkey HK_KILL, (*) => ExitApp()
