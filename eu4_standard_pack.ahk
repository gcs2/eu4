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
global SUBSTACK_COUNT := 8     ; F8 mass siege loop
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
; X fixed; rows spaced 85px apart
; ============================================================
global DIPLO_X           := 155  ; * x of all + buttons
global DIPLO_Y_NEIGHBORS := 505  ; * Neighbouring Countries
global DIPLO_Y_SUBJECTS  := 590  ; * Own Subject Countries (+85)
global DIPLO_Y_OUTRAGED  := 675  ;   Outraged Countries    (+85)
global DIPLO_Y_ALLIES    := 760  ;   Allies                (+85)
global DIPLO_Y_THREAT    := 845  ;   Threatening Countries (+85)

; ============================================================
; State Edicts  (* = verified, 4K + UI 1.3)
; Navigation: b -> 9 -> s  (from clean screen)
; User manually scrolls the state list before triggering.
; Max 11 rows visible at once; set STATE_COUNT to however many are showing.
;
; Row geometry:
;   EDICT_BTN_X          = x of the edict dropdown button (left column)
;   EDICT_BTN_Y_FIRST    = y of first visible state's button
;   EDICT_ROW_H          = row height in px (calibrated: 408-364 = 44)
;
; Dropdown option geometry (opens to the right, x=1000, 70px spacing):
;   Advancement Effort    400
;   Centralization Effort 470
;   Defensive Edict       540
;   Encourage Development 610  <- holy grail
;   Feudal De Jure Law    680
;   Increase Enlistment   750
;   Protect Trade         820
;   Enforce Religious     890
;   Feudal Taxes Edict    960
;   [scroll down 1]
;   No Edict              960  (after WheelDown x1)
; ============================================================
global STATE_COUNT        := 11   ; visible rows - update if fewer showing
global EDICT_BTN_X        := 500  ; * x of edict dropdown button column
global EDICT_BTN_Y_FIRST  := 380  ; * y of first visible state row
global EDICT_ROW_H        := 44   ; * row height (408-364 calibrated)
global EDICT_OPT_X        := 1000 ; * x of dropdown option column
global EDICT_Y_ENCOURAGE   := 610  ; * Encourage Development (4th)
global EDICT_Y_AGE_ABILITY := 960  ; * Age ability edict (9th) — changes each age
                                   ;   Age of Discovery  = Feudal Taxes Edict
                                   ;   Age of Reformation = [next age ability]
global EDICT_Y_NO_EDICT    := 960  ;   No Edict (after 1x WheelDown)

CoordMode "Mouse", "Screen"
SendMode "Event"

; ============================================================
; F8 - Mass Auto-Siege
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
; F5 - Split 16k -> 8 x 2k, then auto-siege all 8
; ============================================================
SplitThenSiege() {
    SplitStack16()
    Sleep WAIT * 6
    MassAutoSiege()
}

; ============================================================
; Diplomacy - Improve Relations
; Opens panel via b -> 0 -> a, clicks target row DIPLOMAT_COUNT times.
; Requires clean screen.
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
; Call with needs_scroll=true for No Edict (1x WheelDown per dropdown)
; Panel must already be open on State Edicts sub-tab.
; User manually scrolls the state list to the desired window first.
; ============================================================
SetAllEdicts(edict_y, needs_scroll := false) {
    global WAIT, STATE_COUNT, EDICT_BTN_X, EDICT_BTN_Y_FIRST, EDICT_ROW_H, EDICT_OPT_X

    Loop STATE_COUNT {
        btn_y := EDICT_BTN_Y_FIRST + (A_Index - 1) * EDICT_ROW_H
        MouseMove EDICT_BTN_X, btn_y, 0
        Sleep WAIT
        Click
        Sleep WAIT * 2   ; wait for dropdown to open

        if needs_scroll {
            ; Move to center of dropdown before scrolling
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

; Open States -> State Edicts panel from clean screen
OpenStateEdicts() {
    global WAIT
    Send "b"
    Sleep WAIT * 4
    Send "9"
    Sleep WAIT * 4
    Send "s"
    Sleep WAIT * 4
}

; ============================================================
; Hotkey bindings
; ============================================================

; --- Siege / Split ---
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

; --- State Edicts (panel must be open, user scrolled to target states) ---
Hotkey "^e", (*) => SetAllEdicts(EDICT_Y_ENCOURAGE)              ; Ctrl+E  Encourage Dev
Hotkey "^-", (*) => SetAllEdicts(EDICT_Y_NO_EDICT, true)         ; Ctrl+-  No Edict
Hotkey "^a", (*) => SetAllEdicts(EDICT_Y_AGE_ABILITY)            ; Ctrl+A  Age ability (9th slot)

; --- Kill ---
Hotkey HK_KILL, (*) => ExitApp()
