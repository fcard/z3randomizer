; Finds and jumps to the Ancilla object main routine
; Input: A (Ancilla object Id)
AncillaExt_JumpToRoutine:
    PHB : PHK : PLB
    TAY
    DEY
    LDA AncillaRoutineBanks, Y : STA $02
    TYA : ASL A : TAY
    LDA AncillaRoutines+0, Y : STA $00
    LDA AncillaRoutines+1, Y : STA $01
    PLB
JML [$0000]

; Load the maximum number of sprites the Ancilla object can draw
; Input:  A (Ancilla object Id)
; Output: A (Maximum sprite count)
AncillaExt_LoadMaxSpriteCount:
    PHB : PHK : PLB
    LDA AncillaMaxSpriteCount-1, X
    PLB
RTL

; Set the special memory address for Ancilla coordinates
; Input: $00 (Y coordinate, word)
; Input: $02 (X coordinate, word)
Ancilla_SetCoordsLong:
    LDA $00 : STA $0BFA, X
    LDA $01 : STA $0C0E, X

    LDA $02 : STA $0C04, X
    LDA $03 : STA $0C18, X
RTL

; ==============================================================================

function AncillaExt_CalculateHiOamIndex(index) = (index-4)>>2

macro AncillaExt_CalculateHiOamIndex()
    TYA : SEC : SBC #$04 : LSR #2 : TAY
endmacro

