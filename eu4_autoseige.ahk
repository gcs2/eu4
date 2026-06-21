#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================
; EU4 Macro Suite
; ============================================================

; --- Time currency ---
; All sleeps are expressed as multiples of WAIT.
; Tune WAIT here and every timing scales proportionally.
;
;   1×  WAIT  =  50ms  — small pause (between key sends)
;   2×  WAIT  = 100ms  — medium pause (after clicks)
;   4×  WAIT  = 200ms  — UI transition (panel open / tab switch)
;   6×  WAIT  = 300ms  — settle pause (after a batch of splits)
;
global WAIT := 50   ; base time unit in ms

; --- General config ---
global UI_SCALE        := 1.3  ; EU4 Options → UI Scale
global SUBSTACK_COUNT  := 8    ; used by F8 mass siege loop only
global DIPLOMAT_COUNT  := 3    ; diplomats to assign per Improve Relations click

; --- Hotkeys ---
; AHK prefixes: ^ = Ctrl  ! = Alt  + = Shift
; Do NOT use bare Esc — EU4 fires it constantly and kills the script
global HK_MASS_SIEGE   := "F8"      ; siege all SUBSTACK_COUNT units
global HK_SINGLE_SIEGE := "F7"      ; single unit per press (any stack size)
global HK_SPLIT_16     := "F6"      ; split 16k → 8 × 2k
global HK_KILL         := "^+F12"   ; Ctrl+Shift+F12 — terminate script

; ============================================================
; Siege button coordinate table  (* = WindowSpy verified, c = computed)
; ============================================================
global BTN_COORDS := Map(
    "3840x2160@1.3",  {x: 600, y: 900},   ; * 4K    / UI 1.3 — calibrated
    "3840x2160@1.0",  {x: 462, y: 692},   ; c 4K    / UI 1.0
    "2560x1440@1.3",  {x: 400, y: 600},   ; c 1440p / UI 1.3
    "2560x1440@1.0",  {x: 308, y: 462}    ; c 1440p / UI 1.0
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
; Diplomacy → Improve Relations coordinates (* = verified)
; Navigation: b → 0 → a  (from clean screen)
; X fixed; Y rows spaced 85px apart
; ============================================================
global DIPLO_X           := 155   ; * x of all + buttons
global DIPLO_Y_NEIGHBORS := 505   ; * Neighbouring Countries
global DIPLO_Y_SUBJECTS  := 590   ; * Own Subject Countries  (+85)
global DIPLO_Y_OUTRAGED  := 675   ;   Outraged Countries     (+85)
global DIPLO_Y_ALLIES    := 760   ;   Allies                 (+85)
global DIPLO_Y_THREAT    := 845   ;   Threatening Countries  (+85)

CoordMode "Mouse", "Screen"
SendMode "Event"

; ============================================================
; F8 — Mass Auto-Siege  (hover over province stack, press F8)
; ============================================================
MassAutoSiege() {
    global SIEGE_BTN_X, SIEGE_BTN_Y, WAIT, SUBSTACK_COUNT
    MouseGetPos &stackX, &stackY

    Loop SUBSTACK_COUNT {
        MouseMove SIEGE_BTN_X, SIEGE_BTN_Y, 0
        Sleep WAIT          ; 1× — move settled
        Click
        Sleep WAIT * 2      ; 2× — button click registered
        MouseMove stackX, stackY, 0
        Sleep WAIT          ; 1× — move settled
        if A_Index < SUBSTACK_COUNT {
            Click
            Sleep WAIT * 2  ; 2× — cycle click registered
        }
    }
}

; ============================================================
; F7 — Single-Shot Auto-Siege  (one press = one unit)
; ============================================================
SingleAutoSiege() {
    global SIEGE_BTN_X, SIEGE_BTN_Y, WAIT
    MouseGetPos &origX, &origY
    MouseMove SIEGE_BTN_X, SIEGE_BTN_Y, 0
    Sleep WAIT              ; 1×
    Click
    Sleep WAIT              ; 1×
    MouseMove origX, origY, 0
    Sleep WAIT              ; 1×
    Click                   ; cycle to next substack
    Sleep WAIT              ; 1×
}

; ============================================================
; F6 — Split 16k army into 8 × 2k substacks
; Pattern: s s s click  s s click  s click click  s
; ============================================================
SplitStack16() {
    global WAIT
    Send "s"
    Sleep WAIT              ; 1× after key
    Send "s"
    Sleep WAIT
    Send "s"
    Sleep WAIT
    Click
    Sleep WAIT * 2          ; 2× after click
    Send "s"
    Sleep WAIT
    Send "s"
    Sleep WAIT
    Click
    Sleep WAIT * 2          ; 2× after click
    Send "s"
    Sleep WAIT
    Click
    Sleep WAIT * 2          ; 2× after click
    Click
    Sleep WAIT * 2          ; 2× after click
    Send "s"
    Sleep WAIT
}

; ============================================================
; F5 — Split 16k → 8 × 2k, then auto-siege all 8
; ============================================================
SplitThenSiege() {
    SplitStack16()
    Sleep WAIT * 6          ; 6× — let EU4 settle after all splits
    MassAutoSiege()
}

; ============================================================
; Diplomacy — Improve Relations
; Opens panel via b → 0 → a, clicks the target country row.
; Requires a clean screen (no panels open).
; ============================================================
ImproveRelations(y_coord) {
    global WAIT, DIPLO_X, DIPLOMAT_COUNT
    Send "b"
    Sleep WAIT * 4          ; 4× — panel opens
    Send "0"
    Sleep WAIT * 4          ; 4× — tab switches
    Send "a"
    Sleep WAIT * 4          ; 4× — sub-tab opens
    MouseMove DIPLO_X, y_coord, 0
    Sleep WAIT              ; 1×
    Loop DIPLOMAT_COUNT {
        Click
        Sleep WAIT          ; 1× — rapid, just enough for each assignment to register
    }
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
Hotkey "^/", (*) => ImproveRelations(DIPLO_Y_NEIGHBORS)   ; Ctrl+/  Neighbouring
Hotkey "^.", (*) => ImproveRelations(DIPLO_Y_SUBJECTS)    ; Ctrl+.  Own Subjects
Hotkey "^,", (*) => ImproveRelations(DIPLO_Y_OUTRAGED)    ; Ctrl+,  Outraged
Hotkey "^m", (*) => ImproveRelations(DIPLO_Y_ALLIES)      ; Ctrl+M  Allies
Hotkey "^n", (*) => ImproveRelations(DIPLO_Y_THREAT)      ; Ctrl+N  Threatening

; --- Kill ---
Hotkey HK_KILL, (*) => ExitApp()
