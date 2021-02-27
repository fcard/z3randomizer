; Change jump table location for ancilla routines
org $08836F
    JML AncillaExt_JumpToRoutine

; Return point for the above jump
org $088373
AncillaExt_Return:
RTS

; Long versions for existing ancilla routines
; using freed space from the above routine
org $088374
Ancilla_SetSafeOam_XY_Long:
    PHB : PHK : PLB
    JSR Ancilla_SetSafeOam_XY
    PLB
RTL

Ancilla_SetOam_XY_Long2:
    PHB : PHK : PLB
    JSR Ancilla_SetOam_XY
    PLB
RTL

warnpc $0883A5 ; usable freed space ends here.
               ; we use the memory from $0883A5 to $088405
               ; for our new sprite sheets.

org $08F6F3
Ancilla_SetOam_XY:

; Change table for max sprite count
org $099CF4
JSL AncillaExt_LoadMaxSpriteCount


